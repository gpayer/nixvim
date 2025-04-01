{ ... }:
{
  plugins = {
    codecompanion = {
      enable = true;

      settings = {
        strategies = {
          agent = { adapter = "gemini"; };
          chat = { adapter = "gemini"; };
          inline = { adapter = "gemini"; };
        };
      };
    };
  };
}
