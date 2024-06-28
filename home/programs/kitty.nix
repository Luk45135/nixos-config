{ inputs, ... }: 
let
  palette = inputs.nix-colors.colorSchemes.catppuccin-mocha.palette;
in {

  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Noto";
      confirm_os_window_close = 0;
      foreground = "#${palette.base05}";
      background = "#${palette.base00}";
      # ...
    };
  };
}