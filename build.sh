#!/usr/bin/env bash

echo "rebuilding nixos"

while ! sudo nixos-rebuild switch
do
  echo "Try again"
done
