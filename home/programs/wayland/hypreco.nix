{ config, pkgs, inputs, lib, ... }:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in with lib; {

  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];


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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  services.hyprpaper = {
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

  # nix-colors colorscheme
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  programs = {
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
      package = pkgs.rofi-wayland;
      plugins = [ pkgs.rofi-emoji ]; # broken in 1.7.5+wayland3 wait until 1.7.6
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
  };


  home.file = { # Hyprlock
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
  };


}