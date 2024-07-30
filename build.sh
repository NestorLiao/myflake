#!/usr/bin/env bash

# nix flake update;  

echo "rebuilding nixos";
while ! sudo nixos-rebuild boot
do
  echo "Try again"
done
