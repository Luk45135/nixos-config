{pkgs, ...}: {
  imports = [
    ./nixvim/nixvim.nix
  ];

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
        searchDownKey = ["^[[B" "$terminfo[kcud1]"];
        searchUpKey = ["^[[A" "$terminfo[kcuu1]"];
      };
      shellAliases = {
        fk = "fuck";
        cat = "bat";
        diff = "batdiff";
        man = "batman";
        grep = "batgrep";
        watch = "batwatch";
      };
    };
    tmux = {
      enable = true;
      clock24 = true;
      baseIndex = 1;
      mouse = true;
      shell = "${pkgs.zsh}/bin/zsh";
      shortcut = "Space";
      terminal = "screen-256color";
      sensibleOnTop = true;
      plugins = with pkgs.tmuxPlugins; [
        catppuccin
      ];
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
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
    bat = {
      enable = true;
      config.theme = "catppuccin";
      themes = {
        catppuccin = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
            sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
      extraPackages = with pkgs.bat-extras; [batman batgrep batwatch batdiff];
    };
    thefuck = {
      enable = true;
      enableZshIntegration = true;
    };
  };
  home.packages = with pkgs; [
    tlrc
    nix-output-monitor
    nvd
    ouch
  ];
}
