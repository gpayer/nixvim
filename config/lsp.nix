{
  createKeymaps,
  pkgs,
  ...
}: {
  config = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          nixd.enable = true;
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

      conform-nvim = {
        enable = true;
        settings = {
          format_after_save = {
            lsp_fallback = "fallback";
          };
          notify_on_error = true;

          formatters_by_ft = {
            nix = ["alejandra"];
          };
        };
      };

      inc-rename = {
        enable = true;
      };
    };

    extraPackages = [
      pkgs.alejandra
    ];

    keymaps = createKeymaps {
      "v" = [
        [
          "<leader>ca"
          ''            function()
                        vim.lsp.buf.code_action()
                      end''
          "LSP code action"
          {raw = true;}
        ]
      ];

      n = [
        [
          "<leader>ra"
          ''            function()
                        local old_name = vim.fn.expand("<cword>")
                        vim.ui.input({ prompt = "New name: ", default = old_name }, function(new_name)
                          if new_name == "" or new_name == old_name then
                            return
                          end
                          vim.cmd('IncRename ' .. new_name)
                        end)
                      end''
          "Rename identifier"
          {raw = true;}
        ]
      ];
    };
  };
}
