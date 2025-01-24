
{ pkgs, createKeymaps, ... }:

let
  lgConf = pkgs.writeText "config.yml" ''
    git:
      branchLogCmd: "git log --graph --color=always --abbrev-commit --decorate --date=relative --format=format:'%C(auto)%h%C(reset) - %C(green)%ai%C(reset) %C(bold white)%s%C(reset) %C(blue)%an%C(reset)%C(auto)%d%C(reset)' {{branchName}}"
      allBranchesLogCmd: "git log --graph --color=always --abbrev-commit --decorate --date=relative --format=format:'%C(auto)%h%C(reset) - %C(green)%ai%C(reset) %C(bold white)%s%C(reset) %C(blue)%an%C(reset)%C(auto)%d%C(reset)' --all"
  '';
in
{
  config = {
    plugins= {
      lazygit = {
        enable = true;

        settings = {
          config_file_path = [ "${lgConf}" ];
        };
      };
    };

    keymaps = createKeymaps {
      n = [
        ["<leader>lg" "<cmd>LazyGit<CR>" "Open LazyGit"]
      ];
    };
  };
}
