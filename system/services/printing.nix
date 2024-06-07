{
  services = {
    printing.enable = true; # Enable CUPS to print documents.
    avahi = { # Enable autodiscovery of network printers
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}