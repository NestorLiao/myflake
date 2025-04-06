{
  pkgs,
  inputs,
  ...
}: let
  myEmacs = inputs.emacs-overlay.packages.${pkgs.system}.emacs-git-pgtk;

  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};

  # This generates an emacsWithPackages function. It takes a single
  # argument: a function from a package set to a list of packages
  # (the packages that will be available in Emacs).
  emacsWithPackages = (unstablePkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
  emacsWithPackages (
    epkgs:
      (with epkgs.melpaStablePackages; [
        # magit
      ])
      ++ (with epkgs.melpaPackages; [
        # vertico
        # consult
        # orderless
        # marginalia

        # go-mode
        # rust-mode
        # envrc
        # ripgrep
        # nix-mode
        # nixpkgs-fmt
        # yaml-mode
        # rustic
        # use-package
      ])
      ++ (with epkgs.elpaPackages; [
        # auctex
      ])
      ++ [
      ]
  )
