{ ... }:

{
  config = {
    plugins = {
      godot.enable = true;

      lsp = {
        enable = true;

        servers = {
          gdscript = {
            enable = true;
            package = null;
          };
        };
      };
    };

    autoCmd = [
      {
        event = "FileType";
        pattern = "gdscript";
        callback.__raw = ''
          function()
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.expandtab = false

            vim.keymap.set("n", "<F4>", "<cmd>GodotRunLast<CR>", { buffer = true })
            vim.keymap.set("n", "<F5>", "<cmd>GodotRun<CR>", { buffer = true })
            vim.keymap.set("n", "<F6>", "<cmd>GodotRunCurrent<CR>", { buffer = true })
            vim.keymap.set("n", "<F7>", "<cmd>GodotRunFZF<CR>", { buffer = true })
          end
        '';
      }
    ];
  };
}
