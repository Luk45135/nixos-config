{inputs, ...}: let
  palette = inputs.nix-colors.colorSchemes.catppuccin-mocha.palette;
in {
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono NFM";
      size = 12;
    };
    settings = {
      confirm_os_window_close = 0;
      hide_window_decorations = "yes";
      foreground = "#${palette.base05}";
      background = "#${palette.base00}";
      # ...
    };
  };
}
