#!/usr/bin/env bash

# nix flake update;  

echo "rebuilding nixos";
while ! sudo nixos-rebuild switch --flake .#mynixos 
do
  echo "Try again"
done
