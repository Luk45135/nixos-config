{ ... }:
{
  programs.nixvim.plugins = {
    cmp = {
      enable = true;
      settings = {
        mapping = {
          __raw = ''
            cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            })
          '';
        };
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
        sources = {
          __raw = ''
            cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'vsnip' },
              -- { name = 'luasnip' },
              -- { name = 'ultisnips' },
              -- { name = 'snippy' },
            }, {
              { name = 'buffer' },
            })
          '';
        }; 
      };
    };
    cmp-nvim-lsp.enable = true;
    luasnip.enable = true;
    cmp-nvim-ultisnips.enable = true;
  };
}
