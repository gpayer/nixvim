{ inputs, system, ... }:
let
  mcphub-nvim = inputs.mcphub-nvim.packages."${system}".default;
  mcp-hub = inputs.mcp-hub.packages."${system}".default;
in
{
  extraPlugins = [mcphub-nvim];
  extraConfigLua = ''
    local function check_file_exists(file_path)
      local file, _ = io.open(file_path, "r")
      if file then
        file:close()
        return true
      else
        return false
      end
    end
    local function get_mcp_hub_config_path()
      local cwd = vim.fn.getcwd()
      local file_path = vim.fs.joinpath(cwd, ".mcphub", "servers.json")
      if check_file_exists(file_path) then
        return file_path
      end
      return vim.fn.expand("~/.config/mcphub/servers.json")
    end
    require("mcphub").setup({
      auto_approve = true,
      config = get_mcp_hub_config_path(),
      cmd = "${mcp-hub}/bin/mcp-hub",
    })
  '';
}

