{ pkgs, lib, createKeymaps, ... }:

{
  imports = [
    ./dap-go.nix
    ../../plugins/godoc.nix
  ];

  config = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          gopls = {
            enable = true;
            settings = {
              gopls = {
                completeUnimported = true;
                usePlaceholders = true;
                analyses = {
                  unusedparams = true;
                };
              };
            };
          };
          templ.enable = true;

          efm = {
            enable = true;
            filetypes = ["go"];

            extraOptions.settings.languages = {
              go = lib.mkForce [
                {
                  __raw = "require 'efmls-configs.formatters.gofmt'";
                }
                {
                  __raw = "require 'efmls-configs.formatters.goimports'";
                }
                {
                  lintCommand = "staticcheck `dirname \${INPUT}`";
                  lintStdin = false;
                  lintIgnoreExitCode = true;
                }
              ];
            };
          };
        };
      };

      godoc = {
        enable = true;

        settings = {
          picker.type = "telescope";
        };
      };
    };

    extraPackages = [ pkgs.go-tools ];

    keymaps = createKeymaps {
      n = [
        ["<leader>gd" "<cmd>GoDoc<CR>" "Open GoDoc"]
      ];
    };
  };
}
