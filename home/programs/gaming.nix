{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    (prismlauncher.override {jdks = [temurin-bin-21 temurin-bin-17 temurin-bin-8];})
    lumafly
    lutris
    heroic
    mangohud
    r2modman
    dolphin-emu
    cemu
    ryujinx
    (inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin.override {pipewire_latency = "48/48000";})
    steamtinkerlaunch
  ];
}
