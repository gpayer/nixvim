{ config, lib, createKeymaps, ... }:
{
  plugins = {
    codecompanion = {
      enable = true;

      settings = {
        adapters = {
          gemini = {
            __raw = ''
              function()
                return require('codecompanion.adapters').extend('gemini', {
                  schema = {
                    model = {
                      default = 'gemini-2.5-pro-exp-03-25',
                    },
                  },
                })
              end
            '';
          };
        };

        strategies = {
          agent = { adapter = "gemini"; };
          chat = { adapter = "gemini"; };
          inline = { adapter = "gemini"; };
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.codecompanion.enable (createKeymaps {
    "n" = [
      ["<leader>aa" "<cmd>CodeCompanionActions<CR>" "Open CodeCompanion Action Palette" { silent = true; }]
      ["<leader>ak" "<cmd>CodeCompanionChat toggle<CR>" "Toggle CodeCompanion Chat" { silent = true; }]
    ];
    "v" = [
      ["ga" "<cmd>CodeCompanionChat Add<cr>" "Add visually selected text to the current CodeCompanion chat" { silent = true; }]
    ];
  });
}
