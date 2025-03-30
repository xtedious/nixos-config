# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  host,
  options,
  lib,
  inputs,
  system,
  unstable,
  ...
}: {
  imports = [
    # Include all .nix files
    ./hardware.nix
    ./packages_fonts.nix
  ];

  # Booting
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };

    # The bootloader
    loader.systemd-boot.enable = true;

    loader.efi = {
      canTouchEfiVariables = true;
    };

    loader.timeout = 10;

    # Remember to set themes
    plymouth.enable = true;
  };

  # Video drivers to be used
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  # Network Stuff
  networking = {
    networkmanager.enable = true;
    hostName = "${host}";
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
  };

  # Set timezone
  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Services
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    # Add something minimal like greetd

    gvfs.enable = true;
    tumbler.enable = true;

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # File stuff
    udev.enable = true;
    envfs.enable = true;
    dbus.enable = true;

    # NFS
    rpcbind.enable = false;
    nfs.server.enable = false;

    fstrim = {
      enable = true;
      interval = "weekly";
    };

    # Input devices
    libinput.enable = true;

    # Bluetooth
    blueman.enable = true;

    # Firmware Updates
    fwupd.enable = true;

    # Power Management daemon
    upower.enable = true;

    # keyring manager
    gnome.gnome-keyring.enable = true;

    # DO SOMETHING ABOUT PRINTING

    # Network discovery
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  # RESOLVE FLATPAK REPOS

  # zram
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # Bluetooth
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General.Enable = "Source,Sink,Media,Socket";
        General.Experimental = true;
      };
    };
  };

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
    	if (
    		subject.isInGroup("users")
    		&& (
    		action.id == "org.freedesktop.login1.reboot" ||
    		action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
    		action.id == "org.freedesktop.login1.power-off" ||
    		action.id == "org.freedesktop.login1.power-off-multiple-sessions"
    		)
    	)
    		{
    	return polkit.Result.YES;
    		}
    	})
  '';
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # NIX management
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  console.keyMap = "us";

  # Open ports in the firewall
  networking.firewall.allowedTCPPorts = [4455];
  networking.firewall.allowedUDPPorts = [4455];
  # Disable firewall
  # networking.firewall.enable = false;

  # This value detemines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # You did not read the comment!!!
}
