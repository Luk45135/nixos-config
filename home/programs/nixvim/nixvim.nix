{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./completion.nix
  ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = [
      {
        action = "<C-d>zz";
        key = "<C-d>";
      }
      {
        action = "<C-u>zz";
        key = "<C-u>";
      }
    ];
    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
    };
    clipboard.providers.wl-copy.enable = true;
    colorschemes.catppuccin.enable = true;
    plugins = {
      treesitter.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>gf" = "git_files";
          "<leader>fg" = "live_grep";
          "<leader>ff" = "find_files";
        };
      };
      web-devicons.enable = true;
      vim-surround.enable = true;
      nvim-autopairs.enable = true;
      lualine.enable = true;
      yanky = {
        enable = true;
        settings.highlight = {
          on_put = true;
          on_yank = true;
          timer = 500;
        };
      };
    };
  };
}
