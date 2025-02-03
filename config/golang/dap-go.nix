{ pkgs, ... }: {
  plugins.dap-go = {
    enable = true;
    settings = {
      dap_configurations = [
       {
          type = "go";
          name = "Attach remote";
          mode = "remote";
          request = "attach";
          connect = {
            host = "127.0.0.1";
            port = 38697;
          };
       } 
      ];
      delve = {
        path = "${pkgs.delve}/bin/dlv";
        port = "38697";
      };
    };
  };
}
