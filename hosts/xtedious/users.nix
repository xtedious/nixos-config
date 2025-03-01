# Users - NOTE: Packages defined on this will be on current user only
{
  pkgs,
  username,
  stable,
  ...
}: let
  inherit (import ./variables.nix) gitUsername;
in {
  users = {
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video"
        "input"
        "audio"
      ];

      # define user packages here
      packages = with pkgs; [
        obsidian
        keepassxc
        discord
        thunderbird
        localsend
        anki
        # Gaming
        mangohud
        # Work Stuff
        libreoffice
        timer
        pom
        # Video Editing and Recording
        krita
        gimp
        libsForQt5.kdenlive
        obs-studio
        # Streaming
        chatterino7
        # Dev stuff
        ollama
        open-webui
        gnumake
        libgcc
        ripgrep
        lua
        cmake
        python3
        picotool
        gcc-arm-embedded
        arduino-ide
        # 3D printing and modeling
        orca-slicer
        freecad-wayland
      ];
    };

    defaultUserShell = pkgs.zsh;
  };

  services.open-webui = {
    package = pkgs.open-webui;
    enable = true;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  environment.shells = with pkgs; [zsh];
  environment.systemPackages = with pkgs; [fzf];

  programs = {
    # Zsh configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "funky";
      };

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      promptInit = ''
        fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

        #pokemon colorscripts like. Make sure to install krabby package
        #krabby random --no-mega --no-gmax --no-regional --no-title -s;

        source <(fzf --zsh);
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
      '';
    };
  };
}
