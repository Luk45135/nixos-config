{ config, pkgs, ... }: {
  
  boot.kernelPackages = pkgs.linuxPackages_latest; # Xe drivers only work on 6.8 and up
  hardware = {
    intelgpu.driver = "xe";
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-vaapi-drivers
        libvdpau-va-gl
        interl-media-driver
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-vaapi-drivers
        libvdpau-va-gl
        interl-media-driver
      ];
    };
  };


}