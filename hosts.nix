{ config, pkgs, ... }:

{ networking.extraHosts = ''

0.0.0.0    google.com     port
'';
}
