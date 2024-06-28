{ ... }: {
  programs = {
    gamemode.enable = true; # Enable Gamemode
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
}