{pkgs, ...}: {
  boot = {
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
