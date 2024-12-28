# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../system/core/boot.nix
    ../../system/core/locale.nix
    ../../system/core/user.nix
    ../../system/core/fonts.nix

    ../../system/nix/nixpkgs.nix
    ../../system/nix/nh.nix

    ../../system/hardware/intelxe.nix
    ../../system/hardware/battery.nix
    ../../system/hardware/ssd.nix

    ../../system/programs/localsend.nix

    ../../system/services/X11.nix
    ../../system/services/printing.nix
    ../../system/services/pipewire.nix
    ../../system/services/flatpak.nix
    ../../system/services/twingate.nix
    ../../system/services/kanata.nix
    ../../system/services/nixos-cli.nix 
  ];

  networking = {
    hostName = "nixhp"; # Define your hostname.
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Home Manager
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    users = {
      "lukasd" = import ../../home/profiles/laptop.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    vscode
    git
    fastfetch
    btop
    wget
    inputs.zen-browser.packages.${pkgs.system}.default    

    wineWowPackages.unstable
    steam-run
    
  ]) ++ (with pkgs.gnomeExtensions; [
    gsconnect
    tray-icons-reloaded
    window-gestures
    battery-usage-wattmeter
  ]);

  services.flatpak.packages = [
  ];

  virtualisation.waydroid.enable = true;

  hardware.sensor.iio.enable = true;

  programs.nix-ld.enable = true;

  services.syncthing = {
    # Syncthing
    enable = true;
    user = "lukasd";
    dataDir = "/home/lukasd/Public";
    configDir = "/home/lukasd/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
    settings = {
      devices = {
        "fedora-server" = {id = "RRKARZM-CQJRN7C-KO77MSF-R6WB5QM-7T6XR7I-QI7TQ63-SDQCNTR-JS33TQC";};
        "nixos" = {id = "FAUONAQ-QBTFPE6-DO6M77F-VZ4GMT2-FIMVLMC-EATBCGV-A7FKEDZ-TP72DQA";};
        "SM-G985F" = {id = "CHN5RFJ-ULJB47F-5ZXALZ5-G76SS5C-4PEUPIB-5P4AV6N-DH752CE-SLPKRAY";};
      };
      folders = {
        "Syncthing" = {
          path = "/home/lukasd/Documents/Syncthing";
          devices = ["fedora-server" "nixos" "SM-G985F"];
        };
      };
      gui = {
        user = "lukasd";
        password = "oZ@Dza*%69HAy243Z5#UfdsE#HNTf7%$";
      };
    };
  };

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
