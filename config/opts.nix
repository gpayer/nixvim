{ ... }:

{
  config = {
    opts = {
      number = true;
      relativenumber = true;
      signcolumn = "number";

      autoindent = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      clipboard = "unnamedplus";

      scrolloff = 15;
    };

    globals = {
      mapleader = " ";
      maplocaleader = " ";
    };

    clipboard.providers.xsel.enable = true;


    diagnostics = {
      float = true;
      severity_sort = false;
      signs = {
        text = {
          # TODO: either use fancy nerdcode icons or show highlighted line numbers
          # "vim.diagnostic.severity.ERROR" = "";
          # "vim.diagnostic.severity.WARN" = "";
          # "vim.diagnostic.severity.INFO" = "";
          # "vim.diagnostic.severity.HINT" = "";
        };
        linehl = {
            "vim.diagnostic.severity.ERROR" = "ErrorMsg";
        };
        numhl = {
          "vim.diagnostic.severity.ERROR" = "DiagnosticSignError";
          "vim.diagnostic.severity.WARN" = "DiagnosticSignWarn";
          "vim.diagnostic.severity.INFO" = "DiagnosticSignInfo";
          "vim.diagnostic.severity.HINT" = "DiagnosticSignHint";
        };
      };
      underline = true;
      update_in_insert = false;
      virtual_text = true;
    };

  };
}
