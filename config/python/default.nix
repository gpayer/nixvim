{ ... }:

{
  config = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          pyright.enable = true;
          ruff.enable = true;
        };
      };
    };
  };
}
