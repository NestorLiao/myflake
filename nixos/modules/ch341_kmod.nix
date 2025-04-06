{
  lib,
  stdenv,
  pkgs,
  kernel
}:

stdenv.mkDerivation {
  pname = "ch341a-linux-driver";
  version = "0.0.0-dev";

  src = ./src;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    # Variable refers to the local Makefile.
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    # Variable of the Linux src tree's main Makefile.
    "INSTALL_MOD_PATH=$(out)"
  ];

  buildFlags = [ "modules" ];
  installTargets = [ "modules_install" ];
}
