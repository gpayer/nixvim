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
  };
}
