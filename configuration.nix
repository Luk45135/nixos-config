# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/nvidia.nix
      ./modules/gaming.nix
      #./modules/stylix.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ]; # Enabling nix commands and flakes
      substituters = ["https://nix-gaming.cachix.org"]; # Enabling cachix
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="]; # and the key for it
    };
    gc = { # Garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    nameservers = [ "192.168.0.18" ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 8384 53317 ]; # Syncthing + LocalSend
      allowedUDPPorts = [ 53317 ]; 
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
    };
  };
  services.resolved = {
    enable = true;
    fallbackDns = [ "9.9.9.9" "9.9.9.11" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };

  # Services  
  services = {
    ratbagd.enable = true; # Start ratabd service to configure logitech mouse with piper
    syncthing = { # Syncthing
      enable = true;
      user = "lukasd";
      dataDir = "/home/lukasd/Public";
      configDir = "/home/lukasd/.config/syncthing";
      overrideDevices = true; 
      overrideFolders = true;
      openDefaultPorts = true;
      settings = {
        devices = {
          "fedora-server" = { id = "RRKARZM-CQJRN7C-KO77MSF-R6WB5QM-7T6XR7I-QI7TQ63-SDQCNTR-JS33TQC"; };
          "nobara-hp" = { id = "BZ5MUTO-IFSONN7-RCNUHC3-WKZX2EV-FRBLOJK-HMFWJ2R-BUVSTOE-XRZSKQA"; };
          "SM-G985F" = { id = "CHN5RFJ-ULJB47F-5ZXALZ5-G76SS5C-4PEUPIB-5P4AV6N-DH752CE-SLPKRAY"; };
        };
        folders = {
          "Syncthing" = {
            path = "/home/lukasd/Documents/Syncthing";
            devices = [ "fedora-server" "nobara-hp" "SM-G985F" ];
          };
          "Music" = {
            path = "/home/lukasd/Music";
            devices = [ "fedora-server" ];
          };
          "PhoneCamera" = {
            path = "/home/lukasd/Pictures/PhoneCamera";
            devices = [ "SM-G985F" ];
          };
        };
        gui = {
          user = "lukasd";
          password = "oZ@Dza*%69HAy243Z5#UfdsE#HNTf7%$";
        };
      };
    };
    printing.enable = true; # Enable CUPS to print documents.
    avahi = { # Enable autodiscovery of network printers
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    libinput.enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "chili";
      wayland.enable = true;
      #settings = {};
    };
  };

  # Virtualization
  virtualisation.waydroid.enable = true;


  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    xkb = { # Configure keymap in X11
      layout = "ch";
      variant = "";
    };
  };

  
  programs = {
    hyprland.enable = true; # Enable the Hyprland wayland compositor
    kdeconnect.enable = true; # Enable kdeconnect
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Configure console keymap
  console.keyMap = "sg";
  
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukasd = {
    isNormalUser = true;
    description = "Lukas Dorji";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      eza
      firefox
      # kate
      webcord
      vesktop
      vscode
      onlyoffice-bin_latest
      anydesk
      # davinci-resolve
      feishin
      # sonixd
      ffmpeg
      pipx
      filezilla
      #lmstudio
      obs-studio
      picard
      scrcpy
      signal-desktop
      tldr
      whatsapp-for-linux
      # obsidian
      localsend
      thunderbird
      qbittorrent
      yt-dlp
    ];
  };

  services.flatpak = {
    enable = true;
    packages = [

    ];
    overrides = {
      global = {
        # Force Wayland by default
        Context.sockets = ["wayland" "!x11" "!fallback-x11"];
        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
          # Force correct theme for some GTK apps
          GTK_THEME = "Adwaita:dark";
        };
      };
    };
  };

  environment = {
    localBinInPath = true;
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      FLAKE = "/home/lukasd/.dotfiles";
    };
  };
  # Use zsh
  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

  # Home Manager
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "lukasd" = import ./home.nix;
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ];})
  ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
    ];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kitty
    waybar
    lf
    rofi-wayland
    rofimoji
    piper
    xfce.thunar
    libsForQt5.ark
    git
    fastfetch
    btop
    grimblast
    pavucontrol
    wl-clipboard
    wlogout
    hyprlock
    sddm-chili-theme
    mpv
    gwenview
    nh
    nix-output-monitor
    nvd
    wget
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
