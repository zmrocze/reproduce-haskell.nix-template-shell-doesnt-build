{
  description = "Simple flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    # flake-utils.url = "github:numtide/flake-utils";
    my-lib.url = "github:zmrocze/nix-lib";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, my-lib, ... }:
    let
      # We leave it to just linux to be able to run `nix flake check` on linux, 
      # see bug https://github.com/NixOS/nix/issues/4265
      # systems = [ "x86_64-linux" ];
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = nixpkgs.lib.genAttrs systems;
      mkNixpkgsFor = system: import nixpkgs {
        # overlays = nixpkgs.lib.attrValues self.overlays;
        inherit system;
      };
      allNixpkgs = perSystem mkNixpkgsFor;

      nixpkgsFor = system: allNixpkgs.${system};
      myLibFor = system: my-lib.lib (nixpkgsFor system);
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./pre-commit.nix
      ];
      inherit systems;
      perSystem = { system, config, pkgs, ... }:
        let
          myLib = myLibFor system;
        in
        {
          _module.args.pkgs = nixpkgsFor system;
          devShells = {

            default = myLib.mergeShells config.devShells.dev-pre-commit
              (
                pkgs.mkShell {
                  packages = [
                    # pkgs.protobuf
                  ];
                  # inputsFrom
                  # shellHook
                }
              );
          };
        };
    };
}
