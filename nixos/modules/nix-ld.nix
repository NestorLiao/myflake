{pkgs, ...}: {
  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.unstable.nix-ld;
  programs.nix-ld.libraries = with pkgs.unstable; [
    stdenv.cc.cc
    openssl.dev
    # openssl
    openssl_3_4
    gcc13
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    libGL
    libva
    # pipewire.lib
    xorg.libxcb
    xorg.libXdamage
    xorg.libxshmfence
    xorg.libXxf86vm
    nix-ld
    sqlite
    libelf
    libayatana-appindicator
    webkitgtk_4_1
    # Required
    glib
    gtk2
    gtk3
    bzip2
    libsoup_2_4
    at-spi2-atk
    atkmm
    cairo
    gdk-pixbuf
    harfbuzz
    librsvg
    libsoup_3
    pango
    openssl
    # Without these it silently fails
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXi
    xorg.libSM
    xorg.libICE
    gnome2.GConf
    nspr
    nss
    cups
    libcap
    SDL2
    libusb1
    dbus-glib
    ffmpeg
    # Only libraries are needed from those two
    libudev0-shim
    # Verified games requirements
    xorg.libXt
    xorg.libXmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    libidn
    tbb
    # Other things from runtime
    flac
    freeglut
    libjpeg
    libpng
    libpng12
    libsamplerate
    libmikmod
    libtheora
    libtiff
    pixman
    speex
    SDL_image
    # SDL_ttf
    SDL_mixer
    # SDL2_ttf
    SDL2_mixer
    libappindicator-gtk2
    libappindicator-gtk3
    libdbusmenu-gtk2
    libindicator-gtk2
    libdbusmenu-gtk3
    libindicator-gtk3
    libcaca
    libcanberra
    libgcrypt
    util-linux
    libvpx
    xorg.libXft
    libvdpau
    # gnome2.pango
    atk
    fontconfig
    freetype
    dbus
    alsa-lib
    expat
  ];

}
