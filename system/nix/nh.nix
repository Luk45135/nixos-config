{
  programs.nh = {
    enable = true;
    flake = "/home/lukasd/.dotfiles";
    clean = {
        enable = true;
        extraArgs = "--keep-since 30d";
    };
  };
}