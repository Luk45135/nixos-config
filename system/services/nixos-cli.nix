{ inputs, ... }:
{
  imports = [inputs.nixos-cli.nixosModules.nixos-cli];
  services.nixos-cli.enable = true;
}
