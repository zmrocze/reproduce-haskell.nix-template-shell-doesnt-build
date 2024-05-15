{
  description = "Flake template: flake-parts + pre-commit-hooks + devshell + pkgsConfig";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake-utils.url = "github:numtide/flake-utils";
    my-lib.url = "github:zmrocze/nix-lib";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, my-lib, ... }:
    let
      myLib = my-lib.lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } ({ config, ... }:
      let
        inherit (config) pkgsFor;
      in
      {
        imports = [
          ./nix/pre-commit.nix
          ./nix/shell.nix
          ./nix/pkgs.nix
        ];
        # systems = [ "x86_64-linux" ];
        systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        perSystem = { system, config, pkgs, ... }:
          {
            _module.args.pkgs = pkgsFor system;
          };
      });
}
