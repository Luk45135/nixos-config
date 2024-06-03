{ config, pkgs, inputs, lib, ... }:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in with lib; {

  # Imports
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];
  
  # Configure Cursor Theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
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


  # nix-colors colorscheme
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lukasd";
  home.homeDirectory = "/home/lukasd";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
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
  ];
  
  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    plugins = [
      # hyprplugins.hyprtrails
    ];
    settings = {
      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &"
        "waybar &"
        "${pkgs.coreutils}/bin/sleep 5; ${pkgs.syncthingtray-minimal}/bin/syncthingtray &"
        "kitty"
        "kdeconnect-indicator"
      ];
      env = [
        "NIXOS_OZONE_WL, 1"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "XDG_SCREENSHOTS_DIR, /home/lukasd/Pictures/Screenshots"
        "GDK_BACKEND, wayland"
        "CLUTTER_BACKEND, wayland"
        "SDL_VIDEODRIVER, wayland"
        "QT_QPA_PLATFORM, wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "MOZ_ENABLE_WAYLAND, 1"
        "WLR_NO_HARDWARE_CURSORS, 1"
        "XCURSOR_SIZE, 24"
      ];
      input = {
        kb_layout = "ch";
        numlock_by_default = true;
        follow_mouse = 1;
        sensitivity = 0.0;
        accel_profile = "flat";
        # force_no_accel = true;
      };
      general = {
        "$mainMod" = "SUPER";
        layout = "dwindle";
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      dwindle = {
        no_gaps_when_only = false;
        force_split = 0;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = "yes";
        preserve_split = "yes";
      };
      bind = [
        "$mainMod, D, exec, kitty"
        "$mainMod, C, killactive, "
        "$mainMod, E, exec, thunar"
        "$mainMod, W, exec, firefox"
        "$mainMod, SPACE, exec, pkill rofi || rofi -show drun"
        "$mainMod, code:60, exec, pkill rofimoji || rofimoji"
        "$mainMod, TAB, workspace, m+1"
        "$mainMod + SHIFT, TAB, workspace, m-1"
        "$mainMod, V, togglefloating,"
        "$mainMod, F, fullscreen"
        " , Print, exec, grimblast --freeze copysave area"
        "$mainMod , Print, exec, grimblast --freeze copysave output"
        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"
        "ALT Shift, Tab, cyclenext, prev"
        "ALT Shift, Tab, bringactivetotop"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
    extraConfig = ''
      monitor = , preferred, auto, auto
      monitor = Unknown-1, disable #Disable ghost monitor
      windowrulev2 = stayfocused, class:^(Rofi)
    '';
  };

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "off";
        splash = false;
        splash_offset = 2.0;
        preload = [ "~/Pictures/system/wallpapers/nix-owo-upscaled.png" ];
        wallpaper = [
          "DVI-D-1,~/Pictures/system/wallpapers/nix-owo-upscaled.png"
          "HDMI-A-1,~/Pictures/system/wallpapers/nix-owo-upscaled.png"
        ];
      };
    };
  };

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
        #la = "ls -la";
      };
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
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
    kitty = {
      enable = true;
      settings = {
        font_family = "Noto";
        confirm_os_window_close = 0;
        foreground = "#${config.colorScheme.palette.base05}";
        background = "#${config.colorScheme.palette.base00}";
        # ...
      };
    };
    rofi = {
      enable = true;
      extraConfig = {
        allow-images = true;
        display-drun = "Applications";
        drun-display-format = "{icon} {name}";
        show-icons = true;
        icon-theme = "Papirus";
      };
      theme = "Arc-Dark";
    };
    firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        Preferences = {
          "browser.startup.homepage" = "https://homepage.local.lukastech.xyz";
        };
      };
      profiles.lukasd = {
        search = {
          force = true;
          # default = "Startpage - English";
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
    
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
          };
        };
        
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          bitwarden
          buster-captcha-solver
          clearurls
          decentraleyes
          #enhancer-for-youtube
          fastforwardteam
          mal-sync
          omnivore
          privacy-badger
          return-youtube-dislikes
          sponsorblock
          startpage-private-search
          greasemonkey
          translate-web-pages
          ublock-origin
          user-agent-string-switcher
        ];
      };
    };  
    waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = [{
        layer = "top";
        position = "top";
        modules-center = [ "hyprland/workspaces" ] ;
        modules-left = [ "custom/startmenu" "hyprland/window" "pulseaudio" "cpu" "memory"];
        modules-right = [ "custom/exit" "idle_inhibitor" "custom/notification" "battery" "tray" "clock" ];
        "hyprland/workspaces" = {
        	format = "{name}"; # if bar-number == true then "{name}" else "{icon}";
        	format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
        	};
        	on-scroll-up = "hyprctl dispatch workspace e+1";
        	on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "clock" = {
    	    format = '' {:L%H:%M}'';
          tooltip = true;
    	    tooltip-format = "<big>{:%A, %d.%B %Y }</big><tt><small>{calendar}</small></tt>";
        };
        "hyprland/window" = {
         	max-length = 25;
          separate-outputs = false;
          rewrite = { "" = " 🙈 No Windows? "; };
        };
        "memory" = {
         	interval = 5;
        	format = " {}%";
          tooltip = true;
        };
        "cpu" = {
        	interval = 5;
        	format = " {usage:2}%";
          tooltip = true;
        };
        "disk" = {
          format = " {free}";
          tooltip = true;
        };
        "network" = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "tray" = {
          spacing = 12;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "sleep 0.1 && pavucontrol";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && wlogout";
        };
        "custom/startmenu" = {
          tooltip = false;
          format = " ";
          # exec = "wofi -show drun";
          # on-click = "pkill wofi && wofi -show drun";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
              activated = "";
              deactivated = "";
          };
          tooltip = "true";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
         	};
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && task-waybar";
          escape = true;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          on-click = "";
          tooltip = false;
        };

      }];
      style = ''
      * {
	      font-size: 16px;
	      font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
    	  font-weight: bold;
      }
      window#waybar {
        background-color: #${config.colorScheme.palette.base00};
        border-bottom: 1px solid rgba(26,27,38,0);
        border-radius: 0px;
        color: #${config.colorScheme.palette.base0F};
      }
      #workspaces {
        background: #${config.colorScheme.palette.base01};
        margin: 2px;
        padding: 0px 1px;
        border-radius: 15px;
        border: 0px;
        font-style: normal;
        color: #${config.colorScheme.palette.base00};
      }
      #workspaces button {
        padding: 0px 5px;
        margin: 4px 3px;
        border-radius: 10px;
        border: 0px;
        color: #${config.colorScheme.palette.base00};
        background: #${config.colorScheme.palette.base0C};
        background-size: 300% 300%;
        animation: gradient_horizontal 15s ease infinite;
        opacity: 0.5;
        transition: ${betterTransition};
      }
      #workspaces button.active {
        padding: 0px 5px;
        margin: 4px 3px;
        border-radius: 10px;
        border: 0px;
        color: #${config.colorScheme.palette.base00};
        background: #${config.colorScheme.palette.base0C};
        background-size: 300% 300%;
        animation: gradient_horizontal 15s ease infinite;
        transition: ${betterTransition};
        opacity: 1.0;
        min-width: 40px;
      }
      #workspaces button:hover {
        border-radius: 10px;
        color: #${config.colorScheme.palette.base00};
        background: #${config.colorScheme.palette.base0C};
        background-size: 300% 300%;
        animation: gradient_horizontal 15s ease infinite;
        opacity: 0.8;
        transition: ${betterTransition};
      }
      @keyframes gradient_horizontal {
        0% {
          background-position: 0% 50%;
        }
        50% {
          background-position: 100% 50%;
        }
        100% {
          background-position: 0% 50%
        }
      }
      tooltip {
        background: #${config.colorScheme.palette.base00};
        border: 1px solid #${config.colorScheme.palette.base0E};
        border-radius: 10px;
      }
      tooltip label {
        color: #${config.colorScheme.palette.base07};
      }
      #window {
        margin: 4px;
        padding: 2px 10px;
        color: #${config.colorScheme.palette.base05};
        background: #${config.colorScheme.palette.base01};
        border-radius: 10px;
      }
      #memory {
        color: #${config.colorScheme.palette.base0F};
        background: #${config.colorScheme.palette.base01};
        margin: 4px;
        padding: 2px 10px;
        border-radius: 10px;
      }
      #clock {
        color: #${config.colorScheme.palette.base01};
        background: #${config.colorScheme.palette.base0C};
        background-size: 300% 300%;
        animation: gradient_horizontal 15s ease infinite;
        margin: 4px;
      	padding: 2px 10px;
      	border-radius: 10px;
      }
      #cpu {
        color: #${config.colorScheme.palette.base07};
       	background: #${config.colorScheme.palette.base01};
       	margin: 4px;
       	padding: 2px 10px;
       	border-radius: 10px;
      }
      #disk {
        color: #${config.colorScheme.palette.base03};
      	background: #${config.colorScheme.palette.base01};
      	margin: 4px;
      	padding: 2px 10px;
      	border-radius: 10px;
      }
      #network {
        color: #${config.colorScheme.palette.base09};
      	background: #${config.colorScheme.palette.base01};
      	margin: 4px;
      	padding: 2px 10px;
      	border-radius: 10px;
      }
      #tray {
        color: #${config.colorScheme.palette.base05};
      	background: #${config.colorScheme.palette.base01};
      	margin: 4px;
      	padding: 2px 10px;
      	border-radius: 10px;
      }
      #pulseaudio {
        color: #${config.colorScheme.palette.base0D};
      	background: #${config.colorScheme.palette.base01};
      	margin: 4px;
      	padding: 2px 10px;
      	border-radius: 10px;
      }
      #custom-notification {
        color: #${config.colorScheme.palette.base0C};
      	background: #${config.colorScheme.palette.base01};
      	margin: 4px;
      	padding: 2px 10px;
      	border-radius: 10px;
      }
      #custom-startmenu {
    	  color: #${config.colorScheme.palette.base00};
        background: #${config.colorScheme.palette.base0C};
        background-size: 300% 300%;animation: gradient_horizontal 15s ease infinite;
	      margin: 4px;
	      padding: 2px 10px;
	      border-radius: 10px;
      }
      #idle_inhibitor {
    	  color: #${config.colorScheme.palette.base09};
	      background: #${config.colorScheme.palette.base01};
	      margin: 4px 0px;
	      padding: 2px 14px;
	      border-radius: 0px;
      }
      #custom-exit {
    	  color: #${config.colorScheme.palette.base0E};
	      background: #${config.colorScheme.palette.base01};
	      border-radius: 10px 0px 0px 10px;
	      margin: 4px 0px;
	      padding: 2px 5px 2px 15px;
      }
      '';
    };
    wlogout = {
      enable = true;
      layout = [
        {
            label = "lock";
            action = "hyprlock";
            text = "Lock";
            keybind = "l";
        }
        {
            label = "hibernate";
            action = "systemctl hibernate";
            text = "Hibernate";
            keybind = "h";
        }
        {
            label = "logout";
            action = "loginctl terminate-user $USER";
            text = "Logout";
            keybind = "e";
        }
        {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
        }
        {
            label = "suspend";
            action = "systemctl suspend";
            text = "Suspend";
            keybind = "u";
        }
        {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
        }
      ];
    };
    mpv = {
      enable = true;
      config = {
        ytdl-format = "bestvideo+bestaudio";
        ao = "pulse";
        audio-device = "auto";
      };
    };
    git = {
      enable = true;
      userName = "LostLukas";
      userEmail = "lukasdorji@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr/hyprlock.conf".text = ''
      background {
          monitor =
          color = rgb(${config.colorScheme.palette.base00})
      #    path = $HOME/.cache/blurred_wallpaper.png   # only png supported for now
      }
      
      input-field {
          monitor =
          size = 200, 50
          outline_thickness = 3
          dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true
          dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
          outer_color = rgb(151515)
          inner_color = rgb(FFFFFF)
          font_color = rgb(10, 10, 10)
          fade_on_empty = true
          fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
          placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
          hide_input = false
          rounding = -1 # -1 means complete rounding (circle/oval)
          check_color = rgb(204, 136, 34)
          fail_color = rgb(204, 34, 34) # if authentication failed, changes outer_color and fail message color
          fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
          fail_transition = 300 # transition time in ms between normal outer_color and fail_color
          capslock_color = -1
          numlock_color = -1
          bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
          invert_numlock = false # change color if numlock is off
          swap_font_color = false # see below
          position = 0, -20
          halign = center
          valign = center
      }
      
      label {
          monitor =
          text = cmd[update:1000] echo "$TIME"
          color = rgba(200, 200, 200, 1.0)
          font_size = 55
          font_family = Noto
          position = -100, -40
          halign = right
          valign = bottom
          shadow_passes = 5
          shadow_size = 10
      }
      
      label {
          monitor =
          text = $USER
          color = rgba(200, 200, 200, 1.0)
          font_size = 20
          font_family = Noto
          position = -100, 160
          halign = right
          valign = bottom
          shadow_passes = 5
          shadow_size = 10
      }
      
      image {
          monitor =
          path = $HOME/Pictures/system/profile.png
          size = 280 # lesser side if not 1:1 ratio
          rounding = -1 # negative values mean circle
          border_size = 4
          border_color = rgb(221, 221, 221)
          rotate = 0 # degrees, counter-clockwise
          reload_time = -1 # seconds between reloading, 0 to reload with SIGUSR2
      #    reload_cmd =  # command to get new path. if empty, old path will be used. don't run "follow" commands like tail -F
          position = 0, 200
          halign = center
          valign = center
      }
    '';


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
  home.sessionVariables = {
    # NIXPKGS_ALLOW_UNFREE = 1;
    # FLAKE = "/etc/nixos";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
