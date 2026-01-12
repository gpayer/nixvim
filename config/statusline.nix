{...}: {
  config = {
    extraConfigLua = ''
      local modes = {
        ["n"] = "NORMAL",
        ["no"] = "NORMAL",
        ["v"] = "VISUAL",
        ["V"] = "VISUAL LINE",
        [""] = "VISUAL BLOCK",
        ["s"] = "SELECT",
        ["S"] = "SELECT LINE",
        [""] = "SELECT BLOCK",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rv"] = "VISUAL REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "VIM EX",
        ["ce"] = "EX",
        ["r"] = "PROMPT",
        ["rm"] = "MOAR",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
      }


      local function mode()
        local current_mode = vim.api.nvim_get_mode().mode
        return string.format(" %s ", modes[current_mode]):upper()
      end

      local function update_mode_colors()
        local current_mode = vim.api.nvim_get_mode().mode
        local mode_color = "%#StatusLineAccent#"
        if current_mode == "n" then
            mode_color = "%#StatusLineAccent#"
        elseif current_mode == "i" or current_mode == "ic" then
            mode_color = "%#StatusLineInsertAccent#"
        elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
            mode_color = "%#StatusLineVisualAccent#"
        elseif current_mode == "R" then
            mode_color = "%#StatusLineReplaceAccent#"
        elseif current_mode == "c" then
            mode_color = "%#StatusLineCmdLineAccent#"
        elseif current_mode == "t" then
            mode_color = "%#StatusLineTerminalAccent#"
        end
        return mode_color
      end

      local function filepath()
        local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
        if fpath == "" or fpath == "." then
            return " "
        end

        return string.format(" %%<%s/", fpath)
      end

      local function filename()
        local fname = vim.fn.expand "%:t"
        if fname == "" then
            return ""
        end
        return fname .. " "
      end

      local function lsp()
        local count = {}
        local levels = {
          errors = "Error",
          warnings = "Warn",
          info = "Info",
          hints = "Hint",
        }

        for k, level in pairs(levels) do
          count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
        end

        local errors = ""
        local warnings = ""
        local hints = ""
        local info = ""

        if count["errors"] ~= 0 then
          errors = " %#LspDiagnosticsError# " .. count["errors"]
        end
        if count["warnings"] ~= 0 then
          warnings = " %#LspDiagnosticsWarning# " .. count["warnings"]
        end
        if count["hints"] ~= 0 then
          hints = " %#LspDiagnosticsHint# " .. count["hints"]
        end
        if count["info"] ~= 0 then
          info = " %#LspDiagnosticsInformation# " .. count["info"]
        end

        return errors .. warnings .. hints .. info .. "%#Normal#"
      end

      local function lspserver()
          local msg = ""
          local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
          local clients = vim.lsp.get_active_clients()
          if next(clients) == nil then
              return msg
          end
          for _, client in ipairs(clients) do
              local filetypes = client.config.filetypes
              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  msg = client.name
                  break
              end
          end
          if msg == "" then
              return ""
          end
          return " %#WarningMsg#" .. msg .. "%#Normal#"
      end

      local function filetype()
        return string.format(" %s ", vim.bo.filetype):upper()
      end

      local function lineinfo()
        if vim.bo.filetype == "alpha" then
          return ""
        end
        return " %P %l:%c "
      end

      local vcs = function()
        local git_info = vim.b.gitsigns_status_dict
        if not git_info or git_info.head == "" then
          return ""
        end
        local added = git_info.added and ("%#GitSignsAdd#+" .. git_info.added .. " ") or ""
        local changed = git_info.changed and ("%#GitSignsChange#~" .. git_info.changed .. " ") or ""
        local removed = git_info.removed and ("%#GitSignsDelete#-" .. git_info.removed .. " ") or ""
        local sep = " "
        if git_info.added == 0 then
          added = ""
          sep = ""
        end
        if git_info.changed == 0 then
          changed = ""
          sep = ""
        end
        if git_info.removed == 0 then
          removed = ""
          sep = ""
        end
        return table.concat {
           "%#Normal# ",
           added,
           changed,
           removed,
           sep,
           "%#GitSignsAdd# ",
           git_info.head,
           " %#Normal#",
        }
      end

      Statusline = {}

      Statusline.active = function()
        return table.concat {
          "%#StatusLine#",
          update_mode_colors(),
          mode(),
          vcs(),
          "%#Normal# ",
          -- filepath(),
          filename(),
          "%#Normal#",
          lsp(),
          "%=",
          lspserver(),
          filetype(),
          "%#StatusLineExtra#",
          lineinfo(),
        }
      end

      function Statusline.inactive()
        return " %F"
      end

      function Statusline.short()
        return "%#StatusLineNC#"
      end

      vim.api.nvim_exec([[
        augroup Statusline
        au!
        au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
        au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
        au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
        augroup END
      ]], false)
    '';
  };
}
