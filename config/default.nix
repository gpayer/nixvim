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
  ];
}
