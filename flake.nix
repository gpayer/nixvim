{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";
    mcp-hub.url = "github:ravitemer/mcp-hub";
  };

  outputs = {
    self,
    nixvim,
    nixpkgs,
    flake-parts,
    flake-utils,
    ...
  } @ inputs: 
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = flake-utils.lib.defaultSystems;
      # [
      #   "x86_64-linux"
      #   "aarch64-linux"
      #   "x86_64-darwin"
      #   "aarch64-darwin"
      # ];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvimModules = self.lib.${system}.nixvimModules;
        makeNixVim = self.lib.${system}.makeNixVim;
        nvim = makeNixVim nixvimModules.default;
        custom-package = self.lib.${system}.custom-package;
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "A nixvim configuration";
          };
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
        };

        devShells = {
          default = pkgs.mkShell {
            name = "Shell with renamed nixvim";

            packages = [
              (custom-package nvim "supereditor")
            ];
          };

          python = pkgs.mkShell {
            name = "Shell with renamed nixvim for python";

            packages = [
              (custom-package (makeNixVim nixvimModules.python) "pyvim")
            ];
          };

          godot = pkgs.mkShell {
            name = "Shell with renamed nixvim for godot";

            packages = [
              (custom-package (makeNixVim nixvimModules.godot) "gdvim")
            ];
          };
        };
      };

      flake = flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        nixvim' = nixvim.legacyPackages.${system};
        createKeymaps = (import ./config/createkeymaps.nix { inherit lib; });
      in
      {
        lib = {
          # TODO: make this more configurable for someone importing this flake
          nixvimModules = {
            default = { ... }: {
              imports = [
                ./config
                ./config/golang
                ./config/frontend
              ];
            };
            python = { ... }: {
              imports = [
                ./config
                ./config/python
              ];
            };
            godot = { ... }: {
              imports = [
                ./config
                ./config/godot
              ];
            };
            base = import ./config/base.nix;
          };

          makeNixVim = module: nixvim'.makeNixvimWithModule {
            inherit pkgs module;
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              inherit createKeymaps inputs system;
            };
          };

          custom-package = nixvim-pkg: customName: pkgs.runCommand
            # derivation name:
            "custom-nvim-${customName}"
            # derivation args:
            {
              # mainProgram should match your symlink's name though
              meta = nixvim-pkg.meta // { mainProgram = customName; };
            }
            # build script:
            ''
              mkdir -p $out/bin
              ln -s "${pkgs.lib.getExe nixvim-pkg}" $out/bin/${customName}
            '';
        };
    });
  };
}
