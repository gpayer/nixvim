{ createKeymaps, ... }:

{
  config = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          nixd.enable = true;

          efm = {
            enable = false;

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
        enable = false;
        setup = {
          # go = {
          #   formatter = ["gofmt" "goimports"];
          #   linter = [ "staticcheck" ];
          # };
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_fallback = "fallback";
            timeout_ms = 500;
          };
          notify_on_error = true;
        };
      };

      inc-rename = {
        enable = true;
      };
    };

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
