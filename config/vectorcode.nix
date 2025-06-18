{ config, lib, pkgs, ... }:

let
  vectorcode-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "vectorcode.nvim";
    version = "0.6.13";
    src = pkgs.fetchFromGitHub {
      owner = "Davidyz";
      repo = "VectorCode";
      rev = "${version}";
      sha256 = "sha256-ok6n0gW6Ahqr7vdoJ2Mj6Kz72mTmSbxIO3bG82T7QQI=";
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
  
  codecompanionEnabled = config.plugins.codecompanion.enable or false;
in
{
  extraPlugins = lib.mkIf codecompanionEnabled [vectorcode-nvim];
  extraConfigLua = lib.mkIf codecompanionEnabled ''
    require("vectorcode").setup()
  '';
}
