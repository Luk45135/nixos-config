{ config, pkgs, ... }: {
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # Xe drivers only work on 6.8 and up
    initrd.kernelModules = [ "xe" ];
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
      intel-media-driver
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-vaapi-driver
      libvdpau-va-gl
      intel-media-driver
    ];
  };
}