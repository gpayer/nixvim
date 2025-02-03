{pkgs, ...}: {
  plugins = {
    cmp-dap.enable = true;
    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "";
          texthl = "DapBreakpointCondition";
        };
        dapLogPoint = {
          text = "";
          texthl = "DapLogPoint";
        };
      };
    };
    dap-ui = {
      enable = true;
      settings = {
        floating.mappings = {
          close = ["<ESC>" "q"];
        };
      };
    };
    dap-virtual-text = {enable = true;};
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>dB";
      action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>\n      ";
      options = {
        silent = true;
        desc = "Breakpoint Condition";
      };
    }
    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>DapToggleBreakpoint<cr>";
      options = {
        silent = true;
        desc = "Toggle Breakpoint";
      };
    }
    {
      mode = "n";
      key = "<leader>dc";
      action = "<cmd>DapContinue<cr>";
      options = {
        silent = true;
        desc = "Continue";
      };
    }
    {
      mode = "n";
      key = "<F5>";
      action = "<cmd>DapContinue<cr>";
      options = {
        silent = true;
        desc = "Continue";
      };
    }
    {
      mode = "n";
      key = "<leader>da";
      action = "<cmd>lua require('dap').continue({ before = get_args })<cr>";
      options = {
        silent = true;
        desc = "Run with Args";
      };
    }
    {
      mode = "n";
      key = "<leader>dC";
      action = "<cmd>lua require('dap').run_to_cursor()<cr>";
      options = {
        silent = true;
        desc = "Run to cursor";
      };
    }
    {
      mode = "n";
      key = "<leader>dg";
      action = "<cmd>lua require('dap').goto_()<cr>";
      options = {
        silent = true;
        desc = "Go to line (no execute)";
      };
    }
    {
      mode = "n";
      key = "<F11>";
      action = "<cmd>DapStepInto<cr>";
      options = {
        silent = true;
        desc = "Step into";
      };
    }
    {
      mode = "n";
      key = "<leader>dj";
      action = "<cmd>lua require('dap').down()<cr>";
      options = {
        silent = true;
        desc = "Down";
      };
    }
    {
      mode = "n";
      key = "<leader>dk";
      action = "<cmd>lua require('dap').up()<cr>";
      options = {
        silent = true;
        desc = "Up";
      };
    }
    {
      mode = "n";
      key = "<leader>dl";
      action = "<cmd>lua require('dap').run_last()<cr>";
      options = {
        silent = true;
        desc = "Run Last";
      };
    }
    {
      mode = "n";
      key = "<F12>";
      action = "<cmd>DapStepOut<cr>";
      options = {
        silent = true;
        desc = "Step Out";
      };
    }
    {
      mode = "n";
      key = "<F10>";
      action = "<cmd>DapStepOver<cr>";
      options = {
        silent = true;
        desc = "Step Over";
      };
    }
    {
      mode = "n";
      key = "<leader>dp";
      action = "<cmd>lua require('dap').pause()<cr>";
      options = {
        silent = true;
        desc = "Pause";
      };
    }
    {
      mode = "n";
      key = "<leader>dr";
      action = "<cmd>DapToggleRepl<cr>";
      options = {
        silent = true;
        desc = "Toggle REPL";
      };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action = "<cmd>lua require('dap').session()<cr>";
      options = {
        silent = true;
        desc = "Session";
      };
    }
    {
      mode = "n";
      key = "<leader>dt";
      action = "<cmd>DapTerminate<cr>";
      options = {
        silent = true;
        desc = "Terminate";
      };
    }
    {
      mode = "n";
      key = "<leader>du";
      action = "<cmd>lua require('dapui').toggle()<cr>";
      options = {
        silent = true;
        desc = "Dap UI";
      };
    }
    {
      mode = "n";
      key = "<leader>dw";
      action = "<cmd>lua require('dap.ui.widgets').hover()<cr>";
      options = {
        silent = true;
        desc = "Widgets";
      };
    }
    {
      mode = ["n" "v"];
      key = "<leader>de";
      action = "<cmd>lua require('dapui').eval()<cr>";
      options = {
        silent = true;
        desc = "Eval";
      };
    }
    {
      mode = "n";
      key = "<leader>df";
      action = "<CMD>lua require('dap.ext.vscode').load_launchjs()<CR><CMD>Telescope dap configurations<CR>";
      options = {desc = "Debug Configurations";};
    }
  ];

  # Allow DAP UI to automatically open and close when possible
  extraConfigLua = ''
    require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
    require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
    require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
  '';

  extraPlugins = [(pkgs.vimPlugins.telescope-dap-nvim)];
}
