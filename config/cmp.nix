{ ... }:

{
  config = {
    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = { 
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-q>"] = cmp.mapping(function(fallback)
                      local luasnip = require("luasnip")
                      if luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                      else
                        fallback()
                      end
                    end, { "i", "s" }),
              })
            '';
          };
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "nvim_lua"; }
            { name = "buffer"; }
            { name = "path"; }
            { name = "luasnip"; }
          ];

          view = {
            docs.auto_open = true;
          };

          window = {
            completion.__raw = ''cmp.config.window.bordered()'';
            documentation.__raw = ''cmp.config.window.bordered()'';
          };
        };
      };
    };
  };
}
