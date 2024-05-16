# README

## Description

Haskell.nix + flake-parts scaffold  

## Use 

You can go through `cabal init` once again with:

```bash
nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ cabal-install ])" --run "cabal init"
```