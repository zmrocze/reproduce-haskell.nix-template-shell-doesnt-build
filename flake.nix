{
  description = "Simple flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    let
      # We leave it to just linux to be able to run `nix flake check` on linux, 
      # see bug https://github.com/NixOS/nix/issues/4265
      # systems = [ "x86_64-linux" ];
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    in

    flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;
      perSystem = { system, config, pkgs, ... }:
        {
          devShells = {
            default = pkgs.mkShell {
              packages = [ 
                # pkgs.protobuf
                ];
              # inputsFrom
              # shellHook
            };
          };
        };
    };
}
