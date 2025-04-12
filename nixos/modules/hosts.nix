let blocklist = builtins.readFile ./offline;
in {
  networking.extraHosts = ''
    # WARNING: Blocking Can be ADDICTIVE.
    ${blocklist}
  '';
}
