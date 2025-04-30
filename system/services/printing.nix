{pkgs, ...}: {
  services = {
    printing.enable = true; # Enable CUPS to print documents.
    avahi = { # Enable autodiscovery of network devices
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
  hardware.sane.enable = true; # Enable SANE for scanning support
  environment.systemPackages = [pkgs.simple-scan];
}
