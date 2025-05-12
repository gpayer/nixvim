{ config, lib, createKeymaps, pkgs, ... }:
{
  plugins = {
    codecompanion = let
      # TODO: remove this as soon as nixpkgs-unstable is updated
      codecompanion-nvim = pkgs.vimUtils.buildVimPlugin rec {
        pname = "codecompanion.nvim";
        version = "15.4.1";
        src = pkgs.fetchFromGitHub {
          owner = "olimorris";
          repo = "codecompanion.nvim";
          rev = "v${version}";
          sha256 = "sha256-QaMhacXZVnrn6yEbREHgaQeClCFt+han9uIbQBpc1vw=";
        };
        dependencies = with pkgs.vimPlugins; [
          plenary-nvim
          telescope-nvim
          mini-pick
          mini-diff
        ];
        nvimSkipModules = [
          "minimal"
          "codecompanion.providers.actions.snacks"
        ];
        meta.homepage = "https://github.com/olimorris/codecompanion.nvim/";
        meta.hydraPlatforms = [ ];
      };
    in {
      enable = true;
      package = codecompanion-nvim;

      luaConfig.pre = lib.readFile ./codecompanion_tools/lsp.lua + ''
        local code_extractor = CodeExtractor:new()
      '';

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
          chat = {
            adapter = "gemini";
            tools = {
              lsp = {
                description = "Extract information for symbols by using the LSP.";
                opts = {
                  user_approval = false;
                };
                callback = {
                  name = "lsp";
                  cmds = [{
                    __raw = ''
                    function(_, args, _)
                      local operation = args.operation
                      last_operation = operation
                      local symbol = args.symbol

                      local bufnr = code_extractor:move_cursor_to_symbol(symbol)

                      if code_extractor.lsp_methods[operation] then
                        code_extractor:call_lsp_method(bufnr, code_extractor.lsp_methods[operation])
                        code_extractor.filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                        return { status = 'success', data = 'Tool executed successfully' }
                      else
                        vim.notify('Unsupported LSP method', vim.log.levels.WARN)
                      end

                      return { status = 'error', data = 'No symbol found' }
                    end,
                    '';
                  }];
                  schema = {
                    type = "function";
                    "function" = {
                      name = "lsp";
                      description = "Act as developer by utilizing LSP methods and code modification capabilities.";
                      parameters = {
                        type = "object";
                        properties = {
                          operation = {
                            type = "string";
                            enum = [
                              "get_definition"
                              "get_references"
                              "get_implementation"
                            ];
                            description = "The action to be performed by the lsp tool";
                          };
                          symbol = {
                            type = "string";
                            description = "The symbol to be processed by the lsp tool";
                          };
                        };
                        required = [
                          "operation" 
                          "symbol"
                        ];
                        additionalProperties = false;
                      };
                      strict = true;
                    };
                  };
                  system_prompt = ''## LSP Tool (`lsp`) Guidelines

## MANDATORY USAGE
Use `get_definition`, `get_references` or `get_implementation` AT THE START of EVERY coding task to gather context before answering. Don't overuse these actions. Think what is needed to solve the task, don't fall into rabbit hole.

## Purpose
Traverses the codebase to find definitions, references, or implementations of code symbols to provide error proof solution
OR
Replace old code with new implementation

## Important
- Wait for tool results before providing solutions
- Minimize explanations about the tool itself
- When looking for symbol, pass only the name of symbol without the object. E.g. use: `saveUsers` instead of `userRepository.saveUsers`
'';
                  handlers = {
                    on_exit = { __raw = ''
                      function(self, agent)
                        code_extractor.symbol_data = {}
                        code_extractor.filetype = ""
                        vim.notify 'Tool executed successfully'
                        return agent.chat:submit()
                      end
                    ''; };
                  };
                  output = {
                    success = { __raw = ''function(self, agent, cmd, stdout)
                      local operation = self.args.operation
                      local symbol = self.args.symbol
                      local buf_message_content = ""

                      for _, code_block in ipairs(code_extractor.symbol_data) do
                        buf_message_content = buf_message_content
                          .. string.format(
                            [[
---
The %s of symbol: `%s`
Filename: %s
Start line: %s
End line: %s
Content:
```%s
%s
```
]],
                            string.upper(operation),
                            symbol,
                            code_block.filename,
                            code_block.start_line,
                            code_block.end_line,
                            code_extractor.filetype,
                            code_block.code_block
                          )
                      end

                      return agent.chat:add_tool_output(self, buf_message_content, buf_message_content)
                    end,
                    error = function(self, agent, cmd, stderr, stdout)
                      return agent.chat:add_tool_output(self, tostring(stderr[1]), tostring(stderr[1]))
                    end
                    ''; };
                  };
                };
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
