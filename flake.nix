{
  #KooL's NixOS-Hyprland at https://github.com/JaKooLit
  description = "xtedious's nixos config";

  inputs = {
    #Nixpkgs
    nixpkgs-stable.url = "nixpkgs/nixos-24.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # Formatter
    alejandra.url = "github:kamadorueda/alejandra/3.1.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    alejandra,
    ...
  }: let
    system = "x86_64-linux";
    host = "xtedious";
    username = "xtedious";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    # So this is where I import stable packages
    stablePkgs = import nixpkgs-stable {
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
          inherit username;
          inherit host;
          stable = stablePkgs;
        };
        modules = [
          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }
          ./hosts/${host}/config.nix
        ];
      };
    };
  };
}
