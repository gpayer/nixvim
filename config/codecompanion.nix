{ config, lib, createKeymaps, pkgs, ... }:
{
  plugins = {
    codecompanion = let
      # TODO: remove this as soon as nixpkgs-unstable is updated
      codecompanion-nvim = pkgs.vimUtils.buildVimPlugin rec {
        pname = "codecompanion.nvim";
        version = "15.1.4";
        src = pkgs.fetchFromGitHub {
          owner = "olimorris";
          repo = "codecompanion.nvim";
          rev = "v${version}";
          sha256 = "sha256-7w7EepUbkoKRRerljJ3q1J13gxQfHmQW4DO43vYQL7E=";
        };
        dependencies = with pkgs.vimPlugins; [
          plenary-nvim
          telescope-nvim
          mini-pick
          mini-diff
        ];
        nvimSkipModules = [ "minimal" ];
        meta.homepage = "https://github.com/olimorris/codecompanion.nvim/";
        meta.hydraPlatforms = [ ];
      };
    in {
      enable = true;
      package = codecompanion-nvim;

      settings = {
        adapters = {
          gemini = {
            __raw = ''
              function()
                return require('codecompanion.adapters').extend('gemini', {
                  schema = {
                    model = {
                      default = 'gemini-2.5-pro-preview-05-06',
                    },
                  },
                })
              end
            '';
          };
        };

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
