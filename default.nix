{ pkgs ? import <nixpkgs> {} }:
let
  src = pkgs.nix-gitignore.gitignoreSource [] ./.;
in
  pkgs.haskellPackages.callCabal2nix "web-server" src {}
