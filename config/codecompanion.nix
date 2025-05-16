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
                      default = 'gemini-2.5-pro-preview-03-25',
                    },
                  },
                })
              end
            '';
          };
          copilot = {
            __raw = ''
              function()
                return require('codecompanion.adapters').extend('copilot', {
                  schema = {
                    model = {
                      default = 'gemini-2.5-pro',
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
          agent = { adapter = "copilot"; };
          chat = {
            adapter = "copilot";
            tools = {
              lsp = {
                description = "Extract information for symbols by querying the LSPs.";
                opts = {
                  user_approval = false;
                };
                callback = {
                  name = "lsp";
                  cmds = [{
                      __raw = ''
                      function(_, args, _)
                        local operation = args.operation
                        local symbol = args.symbol
                        local position = args.position -- New position arg
                        local bufnr = -1

                        -- Validate operation
                        if not operation or not code_extractor.lsp_methods[operation] then
                          vim.notify('Invalid or missing LSP operation: ' .. tostring(operation), vim.log.levels.ERROR)
                          return { status = 'error', data = 'Invalid or missing LSP operation' }
                        end

                        -- Prioritize position if provided and valid
                        if position and position.bufnr and position.row and position.col then
                          vim.notify('Using position parameter', vim.log.levels.INFO)
                          bufnr = code_extractor:move_cursor_to_position(position.bufnr, position.row, position.col)
                          if bufnr == -1 then
                            -- Error message handled within move_cursor_to_position
                            return { status = 'error', data = 'Failed to move cursor to specified position.' }
                          end
                        -- Fallback to symbol if position is not valid/provided
                        elseif symbol and type(symbol) == 'string' and #symbol > 0 then
                          vim.notify('Using symbol parameter', vim.log.levels.INFO)
                          bufnr = code_extractor:move_cursor_to_symbol(symbol)
                          if bufnr == -1 then
                            vim.notify('Could not find symbol: ' .. symbol, vim.log.levels.WARN)
                            return { status = 'error', data = 'Symbol \"' .. symbol .. '\" not found in open buffers.' }
                          end
                        -- Error if neither valid position nor valid symbol is provided
                        else
                          vim.notify('Missing or invalid parameters: requires either a valid symbol string or a position object (bufnr, row, col).', vim.log.levels.ERROR)
                          return { status = 'error', data = 'Missing or invalid parameters: requires symbol or position.' }
                        end

                        -- Clear previous results before new LSP call
                        code_extractor.symbol_data = {}
                        code_extractor.filetype = ""

                        -- Call LSP method at the determined position
                        code_extractor:call_lsp_method(bufnr, code_extractor.lsp_methods[operation])
                        code_extractor.filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })

                        -- Check if data was actually retrieved
                        if #code_extractor.symbol_data > 0 then
                            return { status = 'success', data = 'LSP tool executed successfully for ' .. (position and 'position' or 'symbol: ' .. symbol) }
                        else
                            return { status = 'success', data = 'LSP tool executed, but no results found for ' .. (position and 'position' or 'symbol: ' .. symbol) .. ' using operation ' .. operation }
                        end
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
                              description = "The LSP action to be performed.";
                            };
                            symbol = {
                              type = "string";
                              description = "The symbol to be processed. Use this OR the position parameter.";
                            };
                            position = {
                              type = "object";
                              description = "The exact position (buffer, row, column) to target. Use this OR the symbol parameter. Row and column are 1-based.";
                              properties = {
                                bufnr = {
                                  type = "integer";
                                  description = "The buffer number.";
                                };
                                row = {
                                  type = "integer";
                                  description = "The 1-based row number.";
                                };
                                col = {
                                  type = "integer";
                                  description = "The 1-based column number.";
                                };
                              };
                              required = [ "bufnr" "row" "col" ];
                            };
                          };
                          required = [ "operation" ]; # Require operation, symbol/position checked in code
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

## Important
- The position parameter is more precise than the symbol parameter. Use it when you need to be exact.
- Wait for tool results before providing solutions
- Minimize explanations about the tool itself
- When looking for symbol, pass only the name of symbol without the object. E.g. use: `saveUsers` instead of `userRepository.saveUsers`

## Instructions for Selecting the `col` Value in LSP `position`

1.  **Identify the Target Symbol:** Clearly determine the *exact* symbol (variable, function name, type name, package name, etc.) you want to query on the specified `row`.
2.  **Locate the Symbol on the Line:** Find the starting and ending column numbers for *that specific symbol* on the `row`.
3.  **Choose a Column *Within* the Symbol:** The `col` value **must** correspond to a character *that is part of the symbol's name itself*.
    *   **Best Practice:** Aim for the **first character** or a character **near the beginning or middle** of the symbol name. This is usually the safest and least ambiguous.
    *   **Valid Range:** Any column from the start of the symbol to the end of the symbol (inclusive) *should* work, but stick to the best practice if unsure.
4.  **Avoid Surrounding Syntax:** **Do NOT** select a `col` value that points to:
    *   Whitespace (spaces, tabs) before, after, or around the symbol.
    *   Operators (e.g., `*`, `.`, `=`, `+`). *Exception:* If the operator is part of the symbol itself, which is rare in most languages.
    *   Punctuation (e.g., `(`, `)`, `{`, `}`, `,`, `;`).
    *   Comments (`//`, `/* ... */`).
    *   String literals or struct tags (e.g., `` `json:"..."` ``, `"hello"`).
    *   Keywords *unless* the keyword itself is the target symbol (less common for definitions/references).
5.  **Qualified Names (`package.Symbol`):** If you have a qualified name like `events.EventPeriod`:
    *   To target `EventPeriod`, place the `col` within the characters `E`, `v`, `e`, `n`, `t`, `P`, `e`, `r`, `i`, `o`, `d`.
    *   To target `events` (the package), place the `col` within the characters `e`, `v`, `e`, `n`, `t`, `s`.

**Example:**

*   **File:** `main.go` (bufnr 2)
*   **Line (row):** 59: ` EventPeriod *events.EventPeriod \`json:"event_period"\``
*   **Target Symbol:** The *type* `EventPeriod` from the `events` package.
*   **Location:** The second `EventPeriod` on the line.
*   **Analysis:**
    *   `events` starts at col 16.
    *   `.` is at col 22.
    *   `EventPeriod` (the type) starts at **col 23** and ends at **col 33**.
    *   The struct tag starts at col 35.
*   **Correct `col` values:** Any integer from **23 to 33**.
*   **Recommended `col`:** 23 (start) or ~28 (middle).
*   **Incorrect `col` values:** 22 (`.`), 34 (space), 35+ (struct tag), < 23.
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
          inline = { adapter = "copilot"; };
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
