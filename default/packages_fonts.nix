# Default Packages and Fonts are in here
{
  pkgs,
  inputs,
  unstable,
  ...
}: let
  username = "xtedious";
in {
  pico-dev.enable = true;

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${username}";
      extraGroups = ["networkmanager" "wheel" "libvirtd" "scanner" "lp" "video" "input" "audio"];
    };
    defaultUserShell = pkgs.zsh;
  };

  # These are all the dynamic libraries
  #programs.nix-ld.enable = true;
  #  programs.nix-ld.libraries = with pkgs; [
  #];

  environment.systemPackages = with pkgs; [
    # System Packages/includes basic dev tools
    # dev tools
    gnumake
    libgcc
    clang
    xorg.libX11
    xorg.libXft
    xorg.libXinerama
    lldb # llvm debugger
    vim
    neovim
    wget
    git
    killall
    feh # image viewer
    # Audio
    alsa-utils
    pavucontrol
    pamixer
    mpc # Music
    kitty # Terminal
    fastfetch # fetcher
    btop
    brightnessctl
    unstable.dunst # Notification daemon
    # Notifications
    libnotify
    xdotool # keyboard input
    unzip
    xclip
    ripgrep
    # Desktop Environment
    rofi
    # Graphics
    mesa
    gpu-viewer
    vulkan-tools
    virtualglLib
  ];

  programs = {
    git.enable = true;

    # Default text editor
    neovim.enable = true;

    # File Manager
    thunar.enable = true;

    dconf.enable = true;

    # SSH and GPG keys
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # zsh config
    zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "agnoster";
      };

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  services = {
    # Music Daemon
    mpd.enable = true;

    # Syncthing
    syncthing = {
      enable = true;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk-sans
    font-awesome
  ];
}
