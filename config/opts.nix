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


    diagnostic.settings = {
      float = {
        border = "rounded";
      };
      severity_sort = true;
      signs = {
        text = {
          "__rawKey__vim.diagnostic.severity.ERROR" = "";
          "__rawKey__vim.diagnostic.severity.WARN" = "";
          "__rawKey__vim.diagnostic.severity.INFO" = "";
          "__rawKey__vim.diagnostic.severity.HINT" = "";
        };
        numhl = {
          "__rawKey__vim.diagnostic.severity.ERROR" = "DiagnosticSignError";
          "__rawKey__vim.diagnostic.severity.WARN" = "DiagnosticSignWarn";
          "__rawKey__vim.diagnostic.severity.INFO" = "DiagnosticSignInfo";
          "__rawKey__vim.diagnostic.severity.HINT" = "DiagnosticSignHint";
        };
      };
      underline = true;
      update_in_insert = false;
      virtual_text = true;
    };

  };
}
