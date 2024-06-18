{ config, pkgs, inputs, ... }:
{
  
  home.packages = with pkgs; [
    prismlauncher
    temurin-bin # Java 21 for new versions of minecraft
    #temurin-bin-17
    #temurin-bin-8
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