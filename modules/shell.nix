{ config, pkgs, inputs, ... }:

{
  
  programs = {
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        username = {
          show_always = true;
          style_user = "cyan bold";
          style_root = "red bold";
          format = "[$user]($style) on ";
        };
        hostname = {
          ssh_only = false;
          style = "bright-blue bold";
        };
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      historySubstringSearch = {
        enable = true;
        searchDownKey = [ "^[[B" "$terminfo[kcud1]" ];
        searchUpKey = [ "^[[A" "$terminfo[kcuu1]" ];
      };
      shellAliases = {
        fk = "fuck";
      };
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      package = pkgs.eza;
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
    thefuck = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}