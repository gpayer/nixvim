{ ... }:

{
  config = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          ts_ls.enable = true;
          volar.enable = true;
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = { 
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            vue = [ "prettier" ];
            html = [ "prettier" ];
            css = [ "prettier" ];
          };
        };
      };
      none-ls = {
        enable = true;
        sources = {
          formatting = {
            prettier = {
              enable = true;
              disableTsServerFormatter = true;
            };
          };
        };
      };
    };
  };
}
