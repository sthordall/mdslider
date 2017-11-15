{ pkgs ? (import <nixpkgs> {}) }:

(import ./default.nix) {
  stdenv            = pkgs.stdenv;
  fetchFromGitHub   = pkgs.fetchFromGitHub;
  darkhttpd         = pkgs.darkhttpd;
}
