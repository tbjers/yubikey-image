#!/usr/bin/env bash

nix-build '<nixpkgs/nixos>' \
  --cores 6 \
  -A config.system.build.isoImage \
  -I nixos-config=iso.nix \
  -I nixpkgs=http://nixos.org/channels/nixos-21.05/nixexprs.tar.xz
