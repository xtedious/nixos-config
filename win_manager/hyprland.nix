# Hyprland Config and packages
{
  pkgs,
  config,
  inputs,
  unstable,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # System packages related to hyprland
  environment.systemPackages = with pkgs; [
    # Hypr ecosystem
    hyprpaper
    hyprpicker
    hypridle
    hyprlock
    xdg-desktop-portal-hyprland
    hyprsunset
    unstable.hyprsysteminfo
    unstable.hyprland-qt-support
    hyprcursor
    hyprutils
    wl-clipboard

    mpc # MPD Utility
    playerctl
    nwg-look # settings look
    cliphist # Clipboard Manager
    waybar # Status Bar
    networkmanagerapplet # Network Manager
    rofi # Application selection
  ];

  programs.hyprland.enable = true;
}
