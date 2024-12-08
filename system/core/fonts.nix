{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.droid-sans-mono
      roboto
      source-sans
      source-sans-pro
    ];
  };
}
