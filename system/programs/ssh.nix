{ config, ... }:
{
  programs.ssh = {
    startAgent = true;
    identities = [
      "${config.home.homeDirectory}/.ssh/id_ed25519"
    ];
  };
}
