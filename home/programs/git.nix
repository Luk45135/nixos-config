{ config, ... }:
{
  programs = {
    git = {
      enable = true;
      userName = "LostLukas";
      userEmail = "lukasdorji@gmail.com";
      signing = {
        signByDefault = true;
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    lazygit = {
      enable = true;
    };
  };
}
