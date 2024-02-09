{
  inputs,
  username,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.${username} = {
      userChrome = ''
         /* hides the title bar */
         #titlebar {
           visibility: collapse;
         }

        #nav-bar {
          /* customize this value. */
          --navbar-margin: -38px;

          margin-top: var(--navbar-margin);
          margin-bottom: 0;
          z-index: -100;
          transition: all 0.3s ease !important;
          opacity: 0;
        }

        #navigator-toolbox:focus-within > #nav-bar,
        #navigator-toolbox:hover > #nav-bar
        {
          margin-top: 0;
          margin-bottom: var(--navbar-margin);
          z-index: 100;
          opacity: 1;
        }


      '';

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.display.os-zoom-behavior" = 0;
        "dom.security.https_only_mode" = true;
        "browser.download.panel.shown" = true;
        "identity.fxaccounts.enabled" = false;
        "signon.rememberSignons" = false;
      };

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        block-origin
        ponsorblock
        arkreader
        ridactyl
        outube-shorts-block
      ];
    };
  };
}
