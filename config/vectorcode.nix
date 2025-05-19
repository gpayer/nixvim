{ config, lib, pkgs, ... }:

let
  vectorcode-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "vectorcode.nvim";
    version = "0.6.7";
    src = pkgs.fetchFromGitHub {
      owner = "Davidyz";
      repo = "VectorCode";
      rev = "${version}";
      sha256 = "sha256-BDDvALeQSBVld2gEmcnlpf3GDpdEs64nFyE6cNKpeww=";
    };
    dependencies = with pkgs.vimPlugins; [
      plenary-nvim
    ];
    nvimSkipModules = [
      "codecompanion._extensions.vectorcode.init"
      "vectorcode.cacher.default"
      "vectorcode.cacher.init"
      "vectorcode.cacher.lsp"
      "vectorcode.config"
      "vectorcode"
      "vectorcode.integrations.codecompanion.common"
      "vectorcode.integrations.codecompanion.func_calling_tool"
      "vectorcode.integrations.codecompanion.init"
      "vectorcode.integrations.codecompanion.legacy_tool"
      "vectorcode.integrations.copilotchat"
      "vectorcode.integrations.init"
      "vectorcode.integrations.lualine"
      "vectorcode.jobrunner.cmd"
      "vectorcode.jobrunner.init"
      "vectorcode.jobrunner.lsp"
      "vectorcode.types"
      "vectorcode.utils"
    ];
    meta.homepage = "https://github.com/Davidyz/VectorCode/";
    meta.hydraPlatforms = [ ];
  };
in
{
  extraPlugins = lib.mkIf config.plugins.codecompanion.enable [vectorcode-nvim];
  extraConfigLua = ''
    require("vectorcode").setup()
  '';
}
