#!/usr/bin/env bash

# nix flake update;  

echo "rebuilding nixos";
while ! sudo nixos-rebuild switch --flake .#nixos 
do
  echo "Try again"
done

