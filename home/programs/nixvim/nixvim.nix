{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    extraPackages = with pkgs; [ ripgrep ];
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    opts = {
      number = true;
      relativenumber = true;
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
      telescope = {
        enable = true;
	      keymaps = {
	        "<leader>gf" = "git_files";
	        "<leader>fg" = "live_grep";
	        "<leader>ff" = "find_files";
	      };
      };
      lightline.enable = true;
    };
  };
}
