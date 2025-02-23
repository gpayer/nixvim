{ lib, pkgs, ... }:

let
  inherit (lib.nixvim) defaultNullOpts;
  # inherit (lib) types;

  godoc-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "godoc.nvim";
    version = "1.3.0";
    src = pkgs.fetchFromGitHub {
      owner = "fredrikaverpil";
      repo = "godoc.nvim";
      rev = "v1.3.0";
      sha256 = "sha256-hz8Dz5Ah7D8l5XKgWp85Q4JzyZPOg9WnuFu17F/KCKw=";
    };
    meta.homepage = "https://github.com/fredrikaverpil/godoc.nvim/";
  };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "godoc";

  maintainers = [];

  settingsOptions = {
    command = defaultNullOpts.mkStr "GoDoc" ''
      The desired Vim command to use.
    '';
    window.type = defaultNullOpts.mkStr "split" ''
     split or vsplit
    '';
    highlighting = {
        language = defaultNullOpts.mkStr "go" ''
          The tree-sitter parser used for syntax highlighting.
        '';
    };
    picker = {
      type = defaultNullOpts.mkStr "native" ''
        Picker to use: native, snacks, telescope or mini
      '';
    };
  };

  extraConfig = cfg: opts: {
     plugins.godoc.package = godoc-nvim;
  };
}
