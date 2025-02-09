{ lib, pkgs, ... }:

let
  inherit (lib.nixvim) defaultNullOpts;
  # inherit (lib) types;

  filenav-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "filenav.nvim";
    version = "2025-02-08";
    src = pkgs.fetchFromGitHub {
      owner = "wojciech-kulik";
      repo = "filenav.nvim";
      rev = "c1443082c6be58c5e16ee8d45c24f2091e1aa404";
      sha256 = "sha256-ZHNdroITxMLbFZvt0vOdVLsTjL7+TqisBASP0gg36Dc=";
    };
    meta.homepage = "https://github.com/wojciech-kulik/filenav.nvim/";
  };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "filenav";

  maintainers = [];

  settingsOptions = {
    next_file_key = defaultNullOpts.mkStr "<M-i>" ''
      The key to go to the next file.
    '';
    prev_file_key = defaultNullOpts.mkStr "<M-o>" ''
      The key to go to the previous file.
    '';
    max_history = defaultNullOpts.mkInt 100 ''
      The maximum number of files to keep in the history.
    '';
    remove_duplicates = defaultNullOpts.mkBool true ''
      Whether to remove duplicates from the history.
    '';
  };

  extraConfig = cfg: opts: {
     plugins.filenav.package = filenav-nvim;
  };
}
