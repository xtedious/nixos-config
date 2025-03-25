{
  description = "xtedious's nixos config";

  inputs = {
    #Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Formatter
    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    alejandra,
    ...
  }: let
    system = "x86_64-linux";
    host = "nixos";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    # So this is where I import unstable packages
    unstablePkgs = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem rec {
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit host;
          unstable = unstablePkgs;
        };
        modules = [
          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }
          ./default/config.nix
          ./win_manager/dwm.nix
          ./modules/virt_manager.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.xtedious = import ./users/xtedious/home.nix;
            home-manager.extraSpecialArgs = {
              unstable = unstablePkgs;
            };
          }
        ];
      };
    };
  };
}
