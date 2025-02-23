{ createKeymaps, ... }:

{
  imports = [
    ./dap-go.nix
    ../../plugins/godoc.nix
  ];

  config = {
    plugins = {
      godoc = {
        enable = true;

        settings = {
          picker.type = "telescope";
        };
      };
    };

    keymaps = createKeymaps {
      n = [
        ["<leader>gd" "<cmd>GoDoc<CR>" "Open GoDoc"]
      ];
    };
  };
}
