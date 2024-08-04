{ pkgs, inputs, ... }:

let
  palette = inputs.nix-colors.colorSchemes.catppuccin-mocha.palette;
in {

  imports = [

    ../kitty.nix

    ./rofi.nix
    ./waybar.nix
    ./wlogout.nix
    ./walker.nix

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
      windowrulev2 = stayfocused, class:^(Rofi)
    '';
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

  home.file = { # Hyprlock
    ".config/hypr/hyprlock.conf".text = ''
      background {
          monitor =
          color = rgb(${palette.base00})
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
