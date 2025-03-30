{
  description = "xtedious's nixos config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Wallpapers
    wallpkgs.url = "github:NotAShelf/wallpkgs";
    #NVF
    nvf.url = "github:notashelf/nvf";
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
    wallpkgs,
    nvf,
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
    # Neovim NVF
    packages."x86_64-linux".nvf-neovim =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [./modules/nvf_configuration.nix];
      })
      .neovim;

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
            environment.systemPackages = [
              alejandra.defaultPackage.${system}
              self.packages.${pkgs.stdenv.system}.nvf-neovim
            ];
          }
          ./default/config.nix
          ./win_manager/dwm.nix
          ./modules/virt_manager.nix
          ./modules/pico-dev.nix
          nvf.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.xtedious = import ./users/xtedious/home.nix;
              extraSpecialArgs = {
                inherit inputs;
                unstable = unstablePkgs;
              };
            };
          }
        ];
      };
    };
  };
}
