{ pkgs, ... }: {
  programs.rofi = {
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
}