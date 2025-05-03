{ inputs, system, ... }:
let
  mcphub-nvim = inputs.mcphub-nvim.packages."${system}".default;
in
{
  extraPlugins = [mcphub-nvim];
  extraConfigLua = ''
    require("mcphub").setup({
      auto_approve = true,
      extensions = {
        codecompanion = {
            -- Show the mcp tool result in the chat buffer
            show_result_in_chat = true,
            -- Make chat #variables from MCP server resources
            make_vars = true,
            -- Create slash commands for prompts
            make_slash_commands = true,
        }
      }
    })
  '';
}

