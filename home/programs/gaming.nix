{ config, pkgs, inputs, ... }:
{
  
  home.packages = with pkgs; [
    prismlauncher
    temurin-bin-17
    #temurin-bin-8
    lutris
    mangohud
    r2modman
    dolphin-emu
    #cemu
    ryujinx
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
  ];

}