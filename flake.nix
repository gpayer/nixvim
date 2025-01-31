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
        lib,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        createKeymaps = (import ./config/createkeymaps.nix { inherit lib; });
        # templ = templ.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = self.lib.${system}.nixvimModules.default;
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
          #   inherit (inputs);
            inherit createKeymaps;
          };
        };
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
        };
      };

      flake = flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        lib = {
          nixvimModules = {
            default = import ./config;
            base = import ./config/base.nix;
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
