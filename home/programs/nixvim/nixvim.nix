{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    colorschemes.catppuccin.enable = true;
    plugins = {
      lsp = {
	enable = true;
	servers = {
	  nixd.enable = true;
	};
      };
      treesitter.enable = true;
      telescope.enable = true;
      lightline.enable = true;
    };
  };
}
