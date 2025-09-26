{
  pkgs,
  lib,
  ...
}: {
  config = {
    plugins = {
      lsp = {
        enable = true;

        servers = let
          vue_plugin = {
            name = "@vue/typescript-plugin";
            location = "${lib.getBin pkgs.vue-language-server}/lib/language-tools/packages/language-server";
            languages = ["vue"];
            configNamespace = "typescript";
          };
        in {
          ts_ls = {
            enable = true;
            onAttach.function = ''
              client.server_capabilities.documentFormattingProvider = false
            '';
            filetypes = ["typescript" "javascript" "javascriptreact" "typescriptreact" "vue"];
            extraOptions = {
              init_options = {
                plugins = [vue_plugin];
              };
            };
          };
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
