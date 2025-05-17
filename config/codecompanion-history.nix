{ config, lib, pkgs, createKeymaps, ... }:

{
  extraPlugins = lib.mkIf config.plugins.codecompanion.enable [
    pkgs.vimPlugins.codecompanion-history-nvim
  ];

  keymaps = lib.mkIf config.plugins.codecompanion.enable (createKeymaps {
    "n" = [
      ["<leader>aH" "<cmd>CodeCompanionHistory<CR>" "Open CodeCompanion History" { silent = true; } ]
    ];
  });
}
