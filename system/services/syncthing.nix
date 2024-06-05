{
  services.syncthing = { # Syncthing
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
}