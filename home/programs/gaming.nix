{ pkgs, inputs, ... }:
{

  home.packages = with pkgs; [
    (prismlauncher.override { jdks = [ temurin-bin temurin-bin-17 temurin-bin-8 ]; })
    lumafly
    lutris
    mangohud
    r2modman
    dolphin-emu
    cemu
    ryujinx
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
  ];

}
