{
  lib,
  pkgs,
  config,
  unstable,
  ...
}: {
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
        PICO_SDK_PATH = "${pkgs.pico-sdk}";
      };
      description = "Environment variables";
    };
  };

  config = lib.mkIf config.pico-dev.enable {
    environment.systemPackages = with pkgs;
      [
        unstable.pico-sdk
        picotool
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
