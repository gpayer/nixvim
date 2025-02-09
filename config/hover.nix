{ createKeymaps, ... }:
{
  imports = [
    ../plugins/hover.nix
  ];

  config = {
    plugins.hover = {
      enable = true;
      # providers = ["lsp" "diagnostics"];
    };

    opts = {
      mousemoveevent = true;
    };

    keymaps = createKeymaps {
      n = [
        ["K" "function() require('hover').hover() end" "Show hover information" { raw = true;}]
        ["<MouseMove>" "function() require('hover').hover_mouse() end" "Show hover information on mouse move" { raw = true;}]
      ];
    };
  };
}
