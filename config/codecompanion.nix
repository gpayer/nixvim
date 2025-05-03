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

        # TODO: wait for version 15.x.x to hit nixpkgs-unstable for this to work
        # or create your own codecompanion package
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion";
            opts = {
              make_vars = true;
              make_slash_commands = true;
              show_result_in_chat = true; 
            };
          };
        };

        strategies = {
          agent = { adapter = "gemini"; };
          chat = {
            adapter = "gemini";
            tools = {
              mcp = {
                # Prevent mcphub from loading before needed
                callback = {
                  __raw = ''
                function() 
                        return require("mcphub.extensions.codecompanion") 
                    end
                  '';
                };
                description = "Call tools and resources from the MCP Servers";
              };
            };
          };
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
