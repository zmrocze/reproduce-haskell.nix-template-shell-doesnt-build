{
  description = "Flake template: flake-parts + pre-commit-hooks + devshell + pkgsConfig";

  inputs = {
    haskellNix = {
      url = "github:input-output-hk/haskell.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
  };

  outputs = inputs@{ flake-parts, my-lib, devshell, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        imports = [
          ./nix/pre-commit.nix
          ./nix/haskell.nix
          my-lib.flakeModules.pkgs
          devshell.flakeModule
        ];
        # systems = [ "x86_64-linux" ];
        systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        pkgsConfig.overlays = [
          my-lib.overlays.default
        ];
        perSystem =
          { config, ... }:
          {
            # https://numtide.github.io/devshell/modules_schema.html
            devshells.default = {
              devshell = {
                name = "Project shell";
                motd = ''
                  ❄️ Welcome to the {14}{bold}My haskell template{reset} devshell ❄️
                  $(type -p menu &>/dev/null && menu)
                '';
                packagesFrom = [ config.devShells.haskell ];
                startup.pre-commit.text = config.pre-commit.installationScript;
              };
            };
          };
      };
}
