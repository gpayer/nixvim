{ ... }:

{
  # Import all your configuration modules here
  imports = [
    ./base.nix
    ./cmp.nix
    ./lsp.nix
    ./lazygit.nix
    ./git-conflict.nix
    ./copilot.nix
    ./hover.nix
    ./filenav.nix
    ./dap.nix
    ./codecompanion.nix
    ./codecompanion-history.nix
    ./mcphub.nix
  ];
}
