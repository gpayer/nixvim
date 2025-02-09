{ createKeymaps, ... }:

{
  imports = [
    ../plugins/filenav.nix
  ];

  config = {
    plugins.filenav.enable = true;

    keymaps = createKeymaps {
      n = [
        ["<M-i>" "function() require('filenav').next_file() end" "Go to the next file" { raw = true; silent = true; }]
        ["<M-o>" "function() require('filenav').prev_file() end" "Go to the previous file" { raw = true; silent = true; }]
      ];
    };
  };
}
