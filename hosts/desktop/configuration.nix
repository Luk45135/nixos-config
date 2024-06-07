# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../system/core/boot.nix
      ../../system/core/locale.nix
      ../../system/core/user.nix
      ../../system/core/fonts.nix

      ../../system/nix/nixpkgs.nix
      ../../system/nix/nh.nix

      ../../system/hardware/nvidia.nix
      ../../system/hardware/ssd.nix

      ../../system/programs/steam.nix

      ../../system/services/printing.nix
      ../../system/services/flatpak.nix
      ../../system/services/pipewire.nix
      ../../system/services/syncthing.nix

      inputs.home-manager.nixosModules.default
    ];

  


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
      allowedTCPPorts = [ 53317 ]; # LocalSend
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

  

  # Services  
  services = {
    ratbagd.enable = true; # Start ratabd service to configure logitech mouse with piper
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
    libinput.enable = true;
    xkb = { # Configure keymap in X11
      layout = "ch";
      variant = "";
    };
  };

  programs = {
    hyprland.enable = true;
    hyprlock.enable = true;
  };

  
  
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true; 

  environment = {
    shells = [ pkgs.zsh ];
    localBinInPath = true;
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  # Home Manager
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    users = {
      "lukasd" = import ../../home/profiles/desktop.nix;
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    piper
    git
    fastfetch
    btop
    sddm-chili-theme
    mpv
    gwenview
    wget
    grimblast
    xfce.thunar
    libsForQt5.ark
    pavucontrol
    wl-clipboard
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  services.flatpak.packages = [
    "io.github.lime3ds.Lime3DS"
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
