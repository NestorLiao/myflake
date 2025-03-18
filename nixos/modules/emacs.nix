{
  pkgs,
  inputs,
  ...
}: let
  # Use Emacs from the unstable overlay
  myEmacs = inputs.emacs-overlay.packages.${pkgs.system}.emacs-git-pgtk;

  # Use unstable packages from nixpkgs-unstable
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
        # unstablePkgs.notmuch # Use unstable notmuch
        # unstablePkgs.emacsPackages.pdf-tools
        # unstablePkgs.emacsPackages.nov
        # unstablePkgs.emacsPackages.eat
        # unstablePkgs.emacsPackages.darkroom
        # unstablePkgs.emacsPackages.aggressive-indent
        # unstablePkgs.emacsPackages.pyim
        # unstablePkgs.emacsPackages.sicp
        # unstablePkgs.emacsPackages.racket-mode
      ]
  )
