{ ... }:

{
  config = {
    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = false;
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
                { name = 'nvim_lsp_signature_help' },
                -- { name = 'vsnip' },
                { name = 'luasnip' },
                -- { name = 'ultisnips' },
                -- { name = 'snippy' },
              }, {
                { name = 'buffer' },
                { name = 'path' },
              })
            '';
          };

          view = {
            docs.auto_open = true;
          };

          window = {
            completion.__raw = ''cmp.config.window.bordered()'';
            documentation.__raw = ''cmp.config.window.bordered()'';
          };
        };
      };

      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-path.enable = true;

      luasnip.enable = true;
    };
  };
}
