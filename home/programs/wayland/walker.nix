{ inputs, ... }:
{
  imports = [
    inputs.walker.homeManagerModules.walker
  ];

  programs.walker = {
    enable = false; #wait until hm fix
    runAsService = true;
  };
}
