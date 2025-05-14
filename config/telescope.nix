{ ... }:

{
  config = {
    plugins = {
      telescope = {
        enable = true;

        luaConfig.pre = ''
          local action_state = require('telescope.actions.state')

          local acts = {
            close_buffer = function(prompt_bufnr)
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              current_picker:delete_selection(function(selection)
                vim.api.nvim_buf_delete(selection.bufnr, { force = true })
              end)
            end
          }
        '';

        settings = {
          defaults = {
            layout_config = {
              prompt_position = "top";
            };
            sorting_strategy = "ascending";
            file_ignore_patterns = [ "^node_modules/" "^.git/" "^vendor/" ];
            wrap_results = true;
          };
          pickers = {
            find_files = {
              hidden = true;
            };
            buffers = {
              mappings = {
                i = {
                  "<c-d>".__raw = "acts.close_buffer";
                };
                n = {
                  "<c-d>".__raw = "acts.close_buffer";
                  "x".__raw = "acts.close_buffer";
                };
              };
            };
          };
        };

        extensions = {
          undo = {
            enable = true;
            settings = {
              side_by_side = true;
              mappings = {
                i = {
                  "<cr>".__raw = "require('telescope-undo.actions').restore";
                  "<c-cr>".__raw = "require('telescope-undo.actions').yank_additions";
                  "<s-cr>".__raw = "require('telescope-undo.actions').yank_deletions";
                };
                n = {
                  Y.__raw = "require('telescope-undo.actions').yank_deletions";
                  u.__raw = "require('telescope-undo.actions').restore";
                  y.__raw = "require('telescope-undo.actions').yank_additions";
                };
              };
            };
          };
          ui-select.enable = true;
        };

        keymaps = {
          "<leader>f'" = {
            action = "marks";
            options.desc = "View marks";
          };
          "<leader>f/" = {
            action = "current_buffer_fuzzy_find";
            options.desc = "Fuzzy find in current buffer";
          };
          "<leader>fw" = {
            action = "live_grep";
            options.desc = "Live Grep";
          };
          "<leader>f<CR>" = {
            action = "resume";
            options.desc = "Resume action";
          };
          "<leader>fa" = {
            action = "autocommands";
            options.desc = "View autocommands";
          };
          "<leader>fc" = {
            action = "commands";
            options.desc = "View commands";
          };
          "<leader>fb" = {
            action = "buffers";
            options.desc = "View buffers";
          };
          # "<leader>fc" = {
          #   action = "grep_string";
          #   options.desc = "Grep string";
          # };
          "<leader>fd" = {
            action = "diagnostics";
            options.desc = "View diagnostics";
          };
          "<leader>ff" = {
            action = "find_files";
            options.desc = "Find files";
          };
          "<leader>fF" = {
            action = "find_files hidden=true";
            options.desc = "Find files (+hidden)";
          };
          "<leader>fg" = {
            action = "git_files";
            options.desc = "Find git files";
          };
          "<leader>fG" = {
            action = "git_files hidden=true";
            options.desc = "Find git files (+hidden)";
          };
          "<leader>fh" = {
            action = "help_tags";
            options.desc = "View help tags";
          };
          "<leader>fk" = {
            action = "keymaps";
            options.desc = "View keymaps";
          };
          "<leader>fm" = {
            action = "man_pages";
            options.desc = "View man pages";
          };
          "<leader>fo" = {
            action = "oldfiles";
            options.desc = "View old files";
          };
          "<leader>f\"" = {
            action = "registers";
            options.desc = "View registers";
          };
          "<leader>fr" = {
            action = "lsp_references";
            options.desc = "View symbol references";
          };
          "<leader>fl" = {
            action = "lsp_document_symbols";
            options.desc = "Search local symbols";
          };
          "<leader>fs" = {
            action = "lsp_dynamic_workspace_symbols";
            options.desc = "Search local symbols";
          };
          "<leader>fq" = {
            action = "quickfix";
            options.desc = "Search quickfix";
          };
          # "<leader>gC" = {
          #   action = "git_bcommits";
          #   options.desc = "View git bcommits";
          # };
          "<leader>gB" = {
            action = "git_branches";
            options.desc = "View git branches";
          };
          "<leader>gC" = {
            action = "git_commits";
            options.desc = "View git commits";
          };
          "<leader>gs" = {
            action = "git_status";
            options.desc = "View git status";
          };
          "<leader>gS" = {
            action = "git_stash";
            options.desc = "View git stashes";
          };
          "<leader>u" = {
            action = "undo";
            options.desc = "View undo list";
          };
        };
      };
    };

    autoCmd = [
      {
        event = "User";
        pattern = "TelescopePreviewerLoaded";
        callback.__raw = ''
          function()
            vim.wo.wrap = true
          end
        '';
      }
    ];
  };
}
