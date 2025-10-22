{...}: {
  config = {
    plugins = {
      supermaven = {
        enable = true;

        settings = {
          keymaps = {
            accept_suggestion = "<M-l>";
            clear_suggestions = "<C-e>";
            accept_word = "<M-w>";
          };
        };
      };
    };
  };
}
