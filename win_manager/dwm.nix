# All the packages and settings needed to get dwm working
{
  pkgs,
  config,
  inputs,
  unstable,
  stdenv,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # System packages relating to dwm
  environment.systemPackages = with pkgs; [
    dmenu
    st
    # Status Bar
    unstable.eww
    # Compositer
    unstable.picom
  ];

  # Install dwm
  services = {
    xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      windowManager.dwm.package = pkgs.dwm.overrideAttrs {
        src = ./dwm; # DO A PROPER JOB WITH THIS
      };
    };

    # picom conf --NOTE-- I will replace this with a custom picom.conf at some point
    picom = {
      enable = true;
      settings = {
        blur = {
          method = "gaussian";
          size = 10;
          deviation = 5.0;
        };
      };
      vSync = true;
      fade = true;
      opacityRules = [
        "80:class_g = 'kitty' && focused"
        "60:class_g = 'kitty' && !focused"
        "70:class_g = 'librewolf' && !focused"
        "70:class_g = 'obsidian' && !focused"
      ];
      backend = "glx";
    };
  };
}
