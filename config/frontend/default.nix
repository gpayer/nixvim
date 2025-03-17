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
    };
  };
}
