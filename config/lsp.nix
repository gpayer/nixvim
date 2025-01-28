{ pkgs, lib, createKeymaps, ... }:

{
  config = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          # TODO: add more servers: lua, htmx, docker-compose, docker, (vue?), arduino/c++, python
          # TODO: check how language specific confs can be separated into modules (efm might be difficult)
          nixd.enable = true;
          gopls.enable = true;
          templ.enable = true;
          efm = {
            enable = true;
            filetypes = ["go"];

            # TODO: is this necessary?
            onAttach.function = ''
                if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_clear_autocmds({
                    group = augroup,
                    buffer = bufnr,
                  })
                  vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                      vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                  })
                end
            '';

            extraOptions.init_options = {
              documentFormatting = true;
              documentRangeFormatting = true;
            };

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

        keymaps = {
          diagnostic = {
            "]d" = "goto_prev";
            "[d" = "goto_next";
          };

          lspBuf = {
            # K = "hover"; # this is now in hover.nix
            gr = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
            "<leader>ca" = "code_action";
          };
        };
      };

      efmls-configs = {
        enable = true;
        setup = {
          # go = {
          #   formatter = ["gofmt" "goimports"];
          #   linter = [ "staticcheck" ];
          # };
        };
      };

      inc-rename = {
        enable = true;
      };
    };

    extraPackages = [ pkgs.go-tools ];

    keymaps = createKeymaps {
      "v" = [
        [
          "<leader>ca"
          ''function()
            vim.lsp.buf.code_action()
          end''
          "LSP code action"
          { raw = true; }
        ]
      ];

      n = [
        [
          "<leader>ra"
          ''function()
            local old_name = vim.fn.expand("<cword>")
            vim.ui.input({ prompt = "New name: ", default = old_name }, function(new_name)
              if new_name == "" or new_name == old_name then
                return
              end
              vim.cmd('IncRename ' .. new_name)
            end)
          end''
          "Rename identifier"
          { raw = true; }
        ]
      ];
    };
  };
}
