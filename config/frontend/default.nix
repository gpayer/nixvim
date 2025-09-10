{...}: {
  config = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          ts_ls = {
            enable = true;
            onAttach.function = ''
              client.server_capabilities.documentFormattingProvider = false
            '';
          };
          volar.enable = true;
        };
      };

      conform-nvim = {
        settings = {
          formatters_by_ft = {
            javascript = ["prettier"];
            typescript = ["prettier"];
            vue = ["prettier"];
            html = ["prettier"];
            css = ["prettier"];
          };
        };
      };
    };
  };
}
