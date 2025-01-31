{ createKeymaps, ... }:

{
  imports = [
    ./opts.nix
    ./catppuccin.nix
    ./bufferline.nix
    ./telescope.nix
    ./lualine.nix
  ];

  config = {
    plugins = {
      oil.enable = true;

      treesitter = {
        enable = true;

        settings = {
          highlight = {
            enable = true;
          };
        };
      };

      auto-session.enable = true;

      gitsigns = {
        enable = true;

        settings = {
          signcolumn = false;
          numhl = true;
          linehl = true;
          current_line_blame = true;
        };
      };

      web-devicons.enable = true;

      mini = {
        enable = false;
        modules = {
          statusline = {};
        };
      };

      neogit.enable = true;

      colorizer.enable = true;

      todo-comments.enable = true;
      comment = {
        enable = true;

        settings = {
          toggler = {
            line = "<leader>/";
          };
          opleader = {
            line = "<leader>/";
          };
        };
      };

      harpoon.enable = true;

      which-key.enable = true;

      yanky.enable = true;
      undotree.enable = true;
      tmux-navigator.enable = true;
    };
    keymaps = createKeymaps {
      "n" = [
        ["<esc>" "<cmd>noh<CR>" "Clear search highlight" { silent = true; }]
        ["Y" "yy" "Y => yy"]
        ["<tab>" "<cmd>bnext<CR>" "Switch to next buffer"]
        ["<S-tab>" "<cmd>bprev<CR>" "Switch to previous buffer"]
        ["<leader>e" "function () require('oil').open_float() end" "Open oil floating window" { raw = true; }]
        ["<leader>go" "function () require('neogit').open({ kind = 'auto'}) end" "Open neogit" { raw = true; }]
        ["<leader>x" "<cmd>bdelete<CR>" "Close buffer"]
        ["<leader>cp" "<cmd> cprev<CR>" "Previous entry in quickfix list"]
        ["<leader>cn" "<cmd> cnext<CR>" "Next entry in quickfix list"]
        ["<leader>cP" "<cmd> cfirst<CR>" "First entry in quickfix list"]
        ["<leader>cN" "<cmd> clast<CR>" "Last entry in quickfix list"]
        ["<leader>cc" "<cmd> cclose<CR>" "Close quickfix list"]
        ["<leader>lp" "<cmd> lprev<CR>" "Previous entry in location list"]
        ["<leader>ln" "<cmd> lnext<CR>" "Next entry in location list"]
        ["<leader>lP" "<cmd> lfirst<CR>" "First entry in location list"]
        ["<leader>lN" "<cmd> llast<CR>" "Last entry in location list"]
        ["<leader>lc" "<cmd> lclose<CR>" "Close location list"]
        ["<leader><Tab>" "<cmd> b#<CR>" "Switch to previously used buffer" ]
        ["<leader>h" ''function () require("harpoon.mark").add_file() end'' "Add file to harpoon list" { raw = true; }]
        ["<C-e>" "<cmd> Telescope harpoon marks<CR>" "open harpoon list" ]
        ["[t" ''function ()
          require("todo-comments").jump_prev()
        end'' "Next TODO" { raw = true; }]
        ["]t" ''function ()
          require("todo-comments").jump_next()
        end'' "Previous TODO" { raw = true; }]
        ["<leader>ft" "<cmd> TodoTelescope<CR>" "Find TODOs"]
        ["p" "<Plug>(YankyPutAfter)" "paste after" ]
        ["P" "<Plug>(YankyPutBefore)" "paste before" ]
        ["gp" "<Plug>(YankyGPutAfter)" "paste after" ]
        ["gP" "<Plug>(YankyGPutBefore)" "paste before" ]
        ["<C-n>" "<Plug>(YankyCycleForward)" "yanky cycle forward" ]
        ["<C-p>" "<Plug>(YankyCycleBackward)" "yanky cycle backward" ]
        ["<C-h>" "<cmd>lua require('tmux-navigator').left()<CR>" "tmux navigate left" ]
        ["<C-j>" "<cmd>lua require('tmux-navigator').down()<CR>" "tmux navigate down" ]
        ["<C-k>" "<cmd>lua require('tmux-navigator').up()<CR>" "tmux navigate up" ]
        ["<C-l>" "<cmd>lua require('tmux-navigator').right()<CR>" "tmux navigate right" ]
        # gitsigns
        ["]c" ''function()
            vim.schedule(function()
              require("gitsigns").next_hunk()
            end)
          end
        '' "Go to next hunk" { raw = true; }]
        ["[c" ''function()
            vim.schedule(function()
              require("gitsigns").prev_hunk()
            end)
          end
        '' "Go to next hunk" { raw = true; }]
        ["<leader>rh" ''
          function()
            require("gitsigns").reset_hunk()
          end''
          "Reset hunk" { raw = true; }]

        ["<leader>ph" ''
          function()
            require("gitsigns").preview_hunk()
          end''
          "Preview hunk" { raw = true; }]

        ["<leader>gb" ''
          function()
            require('gitsigns').blame_line()
          end''
          "Blame line" { raw = true; }]

        ["<leader>td" ''
          function()
            require("gitsigns").toggle_deleted()
          end''
          "Toggle deleted" { raw = true; }]
      ];
    };
  };
}
