{
  pkgs,
  lib,
  ...
}: {
  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };
  systemd.user.services.kdeconnect-indicator.Unit.Requires = lib.mkForce []; # https://github.com/nix-community/home-manager/issues/6191
}
