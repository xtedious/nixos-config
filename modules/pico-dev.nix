{
  lib,
  pkgs,
  config,
  ...
}: let
  pico-sdk-200 = pkgs.pico-sdk.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "pico-sdk";
      rev = "2.0.0";
      sha256 = "sha256:0h2j9g7z87gqv59mjl9aq7g0hll0fkpz281f4pprhjxww6789abp";
      fetchSubmodules = true;
    };
  });
in {
  options.pico-dev = {
    enable = lib.mkEnableOption "Enable the Pico Development Environment";

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional pkgs to install";
    };

    # Add tinyUSB
    pico-sdk.fetchSubmodules = true;

    env-variables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        PICO_SDK_PATH = "${pico-sdk-200}/libs/pico-sdk";
      };
      description = "Environment variables";
    };
  };

  config = lib.mkIf config.pico-dev.enable {
    environment.systemPackages = with pkgs;
      [
        pico-sdk-200
        clang-tools
        python3
        cmake
        gcc-arm-embedded
        # Add a debugger
      ]
      ++ config.pico-dev.extraPackages;

    environment.variables = config.pico-dev.env-variables;
  };
}
