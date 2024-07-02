{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    
    defaultEditor = true;
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
      cmp.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-ultisnips.enable = true;
      treesitter.enable = true;
      telescope = {
        enable = true;
	  keymaps = {
	    "<leader>gf" = "git_files";
	    "<leader>fg" = "live_grep";
	    "<leader>ff" = "find_files";
	  };
      };
      lualine.enable = true;
    };
  };
}
