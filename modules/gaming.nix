{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
  services.pipewire.lowLatency = {
    enable = true;
    quantum = 64;
    rate = 48000;
  };
  programs = {
    gamemode.enable = true; # Enable Gamemode
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
  users.users.lukasd.packages = with pkgs; [
    prismlauncher
    temurin-bin-17
    temurin-bin-8
    lutris
    mangohud
    r2modman
    dolphin-emu
    cemu
    ryujinx
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    # inputs.nix-gaming.packages.${pkgs.system}.osu-stable
  ];
}