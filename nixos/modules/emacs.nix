# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{pkgs, ...}: let
  # The let expression below defines a myEmacs binding pointing to the
  # current stable version of Emacs. This binding is here to separate
  # the choice of the Emacs binary from the specification of the
  # required packages.
  myEmacs = pkgs.emacs30-gtk3;
  # This generates an emacsWithPackages function. It takes a single
  # argument: a function from a package set to a list of packages
  # (the packages that will be available in Emacs).
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
  # The rest of the file specifies the list of packages to install. In the
  # example, two packages (magit and zerodark-theme) are taken from
  # MELPA stable.
  emacsWithPackages (epkgs:
    (with epkgs.melpaStablePackages; [
      magit # ; Integrate git <C-x g>
      zerodark-theme # ; Nicolas' theme
    ])
    # Two packages (undo-tree and zoom-frm) are taken from MELPA.
    ++ (with epkgs.melpaPackages; [
      # undo-tree # ; <C-x u> to show the undo tree
      # zoom-frm # ; increase/decrease font size for all buffers %lt;C-x C-+>
      company
      counsel
      direnv
      ivy
      ivy-pass
      lsp-mode
      lsp-ui
      markdown-mode
      rust-mode
      ripgrep
      nix-mode
      nixpkgs-fmt
      nord-theme
      vterm
      yaml-mode
      rustic
      smartparens
      use-package
    ])
    # Three packages are taken from GNU ELPA.
    ++ (with epkgs.elpaPackages; [
      auctex # ; LaTeX mode
      beacon # ; highlight my cursor when scrolling
      nameless # ; hide current package name everywhere in elisp code
    ])
    # notmuch is taken from a nixpkgs derivation which contains an Emacs mode.
    ++ [
      pkgs.notmuch # From main packages set
    ])
