{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.mkShell {
  nativeBuildInputs = [
    # builder tools
    pkgs.cargo
    pkgs.rust-analyzer
    pkgs.rustc
    pkgs.rustup
  ];
}
