{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/db200f7cf4a7edff239d745390f413e706871eab.tar.gz") {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.which
    pkgs.htop
    pkgs.zlib
  ];
}
