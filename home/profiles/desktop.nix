{ config, pkgs, inputs, ... }:

{

  imports = [
    
    ../programs/shell.nix
    ../programs/git.nix
    ../programs/firefox.nix
    ../programs/gaming.nix
    ../programs/wayland/hypreco.nix

    ../services/kdeconnect.nix
    
  ];

  home = {
    username = "lukasd";
    homeDirectory = "/home/lukasd";
    stateVersion = "23.11"; # Don't change this!
    pointerCursor = { # Configure Cursor Theme
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    packages = with pkgs; [
      # kate
      vesktop
      vscode
      onlyoffice-bin_latest
      anydesk
      # davinci-resolve
      feishin
      # sonixd
      streamrip
      ffmpeg
      filezilla
      #lmstudio
      obs-studio
      picard
      scrcpy
      signal-desktop
      whatsapp-for-linux
      obsidian
      localsend
      thunderbird
      qbittorrent
      yt-dlp
    ];
  };

  # Theming
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
      # package = pkgs.adwaita-qt;
    };
  };
  gtk = {
    enable = true;
    font = {
      name = "Noto";
      size = 12;
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };

  };
  
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };


  # The home.packages option allows you to install Nix packages into your
  # environment.
  #home.packages = [];
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')


  programs = {
    mpv = {
      enable = true;
      config = {
        ytdl-format = "bestvideo+bestaudio";
        ao = "pulse";
        audio-device = "auto";
        hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";
        gpu-context = "wayland";
        force-window = true;
      };
    };
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {


    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lukasd/etc/profile.d/hm-session-vars.sh
  #

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
