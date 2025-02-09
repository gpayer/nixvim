{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hover";
  package = "hover-nvim";

  maintainers = [];

  extraOptions = {
    providers = lib.mkOption {
      type = types.listOf types.str;
      default = ["lsp" "diagnostic"];
      description = "The providers to use for hover information.";
    };
  };

  settingsOptions = {
    preview_opts.border = defaultNullOpts.mkStr "single" ''
      The border style for the hover window.
    '';

    preview_window = defaultNullOpts.mkBool false ''
      Whether to open the hover window in a preview window.
    '';

    init = defaultNullOpts.mkLuaFn "function() end" ''internal use only'';
  };

  extraConfig = cfg: opts: {
    plugins.hover.settings.init = ''function()
    '' + (lib.concatStringsSep "\n" (lib.map (p: "require('hover.providers." + p + "')" ) cfg.providers))
    + ''
    end
    '';
  };
}
