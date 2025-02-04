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
      eadirection = "ver";
      equalalways = true;
    };

    clipboard.providers.xsel.enable = true;


    diagnostics = {
      float = true;
      severity_sort = false;
      signs = {
        text = {
          # TODO: this does not work yet
          "vim.diagnostic.severity.ERROR" = "";
          "vim.diagnostic.severity.WARN" = "";
          "vim.diagnostic.severity.INFO" = "";
          "vim.diagnostic.severity.HINT" = "H";
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
