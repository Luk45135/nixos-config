{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # Xe drivers only work on 6.8 and up
    initrd.kernelModules = ["xe"];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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
