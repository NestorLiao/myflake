{
  inputs,
  pkgs,
  lib,
  userSetting,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.unstable.firefox-devedition.override {
      nativeMessagingHosts = [
        # pkgs.tridactyl-native
        pkgs.keepassxc
      ];
    };

    policies = {
      # mostly overwritten by nix and the user.js in ./settings.nix
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      OfferToSaveLogins = false;
      FirefoxHome = {
        Search = false;
        Pocket = false;
        Snippets = false;
        Highlights = false;
        TopSites = false;
      };
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DefaultDownloadDirectory = "\${home}/save";
      OfferToSaveLoginsDefault = false;
      PromptForDownloadLocation = true;
      SearchSuggestEnabled = false;
      TranslateEnabled = false;
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
      SearchBar = "unified";
      PasswordManagerEnabled = false;
      NoDefaultBookmarks = true;
      DontCheckDefaultBrowser = true;
      DisableSetDesktopBackground = true;
      DisableSystemAddonUpdate = true;
      ExtensionUpdate = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      DisableFeedbackCommands = true;
      SearchEngines.Default = "Google";
      BlockAboutAddons = true;
      DisableFormHistory = true;
      AppAutoUpdate = false;
      DisableAppUpdate = true;
    };

    profiles.firefox = {
      userChrome = ''
        @-moz-document url(chrome://browser/content/browser.xhtml) {
              /* ########  Sidetabs Styles  ######### */
              /* Set Bookerly for all Firefox UI */
              * {
                  font-family: Bookerly !important
              }
              #navigator-toolbox { font-family:Bookerly !important }
              #TabsToolbar { font-family: Bookerly !important }
              #sidebar-header {
                display: none;
              }

              #statuspanel { display: none !important; }
              :root[tabsintitlebar] #titlebar:-moz-window-inactive {
                opacity: 1 !important;
              }

              #TabsToolbar {
              	display: none !important;
              }

              #navigator-toolbox[fullscreenShouldAnimate] {
                  transition: none !important;
              }

              #contentAreaContextMenu #context-openlinkincurrent,
              #contentAreaContextMenu #context-openlinkinusercontext-menu,
              #contentAreaContextMenu #context-bookmarklink,
              #contentAreaContextMenu #context-selectall,
              #contentAreaContextMenu #context-sendlinktodevice,
              #contentAreaContextMenu #context-sendpagetodevice,
              #contentAreaContextMenu #context-sep-sendlinktodevice,
              #contentAreaContextMenu #context-sep-sendpagetodevice,
              #contentAreaContextMenu #context-viewpartialsource-selection {
              	display: none !important;
              }


              :root {
              	scrollbar-color: #ffffff #FFFFFF;
              	scrollbar-width: none;
              }
              *{ scrollbar-width: none !important; } }

              *{ scrollbar-width: none }
              #navigator-toolbox,
              #TabsToolbar,
              #tabbrowser-tabs {
                background-color: #FFFFFFF !important;
              }

              :root{
                --uc-autohide-toolbox-delay: 200ms; /* Wait 0.1s before hiding toolbars */
                --uc-toolbox-rotation: 82deg;  /* This may need to be lower on mac - like 75 or so */
              }

              :root[sizemode="maximized"]{
                --uc-toolbox-rotation: 88.5deg;
              }

              @media  (-moz-platform: windows){
                :root:not([lwtheme]) #navigator-toolbox{ background-color: -moz-dialog !important; }
              }

              :root[sizemode="fullscreen"],
              :root[sizemode="fullscreen"] #navigator-toolbox{ margin-top: 0 !important; }

              #navigator-toolbox{
                --browser-area-z-index-toolbox: 3;
                position: fixed !important;
                background-color: var(--lwt-accent-color,black) !important;
                transition: transform 82ms linear, opacity 82ms linear !important;
                transition-delay: var(--uc-autohide-toolbox-delay) !important;
                transform-origin: top;
                transform: rotateX(var(--uc-toolbox-rotation));
                opacity: 0;
                line-height: 0;
                z-index: 1;
                pointer-events: none;
              }
              :root[sessionrestored] #urlbar[popover]{
                pointer-events: none;
                opacity: 0;
                transition: transform 82ms linear var(--uc-autohide-toolbox-delay), opacity 0ms calc(var(--uc-autohide-toolbox-delay) + 82ms);
                transform-origin: 0px calc(0px - var(--tab-min-height) - var(--tab-block-margin) * 2);
                transform: rotateX(89.9deg);
              }
              #mainPopupSet:has(> [panelopen]:not(#ask-chat-shortcuts,#tab-preview-panel)) ~ toolbox #urlbar[popover],
              #navigator-toolbox:is(:hover,:focus-within) #urlbar[popover],
              #urlbar-container > #urlbar[popover]:is([focused],[open]){
                pointer-events: auto;
                opacity: 1;
                transition-delay: 33ms;
                transform: rotateX(0deg);
              }
              #mainPopupSet:has(> [panelopen]:not(#ask-chat-shortcuts,#tab-preview-panel)) ~ toolbox,
              #navigator-toolbox:has(#urlbar:is([open],[focus-within])),
              #navigator-toolbox:hover,
              #navigator-toolbox:focus-within{
                transition-delay: 33ms !important;
                transform: rotateX(0);
                opacity: 1;
              }
              /* This makes things like OS menubar/taskbar show the toolbox when hovered in maximized windows.
               * Unfortunately it also means that other OS native surfaces (such as context menu on macos)
               * and other always-on-top applications will trigger toolbox to show up. */
              @media (-moz-bool-pref: "userchrome.autohide-toolbox.unhide-by-native-ui.enabled"){
                :root[sizemode="maximized"]:not(:hover){
                  #navigator-toolbox:not(:-moz-window-inactive),
                  #urlbar[popover]:not(:-moz-window-inactive){
                    transition-delay: 33ms !important;
                    transform: rotateX(0);
                    opacity: 1;
                  }
                }
              }

              #navigator-toolbox > *{ line-height: normal; pointer-events: auto }

              #navigator-toolbox,
              #navigator-toolbox > *{
                width: 100vw;
                -moz-appearance: none !important;
              }

              /* These two exist for oneliner compatibility */
              #nav-bar{ width: var(--uc-navigationbar-width,100vw) }
              #TabsToolbar{ width: calc(100vw - var(--uc-navigationbar-width,0px)) }

              /* Don't apply transform before window has been fully created */
              :root:not([sessionrestored]) #navigator-toolbox{ transform:none !important }

              :root[customizing] #navigator-toolbox{
                position: relative !important;
                transform: none !important;
                opacity: 1 !important;
              }

              #navigator-toolbox[inFullscreen] > #PersonalToolbar,
              #PersonalToolbar[collapsed="true"]{ display: none }

              /* Uncomment this if tabs toolbar is hidden with hide_tabs_toolbar.css */
               /*#titlebar{ margin-bottom: -9px }*/

              /* Uncomment the following for compatibility with tabs_on_bottom.css - this isn't well tested though */
              /*
              #navigator-toolbox{ flex-direction: column; display: flex; }
              #titlebar{ order: 2 }
              */




                                    }
      '';

      # nav-bar, #urlbar-container, #searchbar { visibility: collapse !important; }
      # extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
      #   # tridactyl
      #   ublacklist
      #   vimium-c
      #   decentraleyes
      #   clearurls
      #   disconnect
      #   ublock-origin
      #   istilldontcareaboutcookies
      #   keepassxc-browser
      #   sponsorblock
      # ];

      settings = {
        "browser.tabs.closeTabByDblclick" = true;
        # disable first-run onboarding
        "browser.aboutwelcome.enabled" = false;
        "general.smoothscroll" = false;
        "browser.tabs.closeWindowWithLastTab" = false;
        "full-screen-api.transition.timeout" = 0;
        "full-screen-api.warning.delay" = 0;
        "full-screen-api.warning.timeout" = 0;
        "browser.tabs.tabClipWidth" = 999;
        "places.history.enabled" = false;
        "services.sync.engine.history" = false;
        "widget.non-native-theme.scrollbar.style" = 3;
        "ui.key.menuAccessKeyFocuses" = false;
        "ui.key.menuAccessKey" = 17;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # "browser.display.os-zoom-behavior" = 0;
        "app.update.auto" = false;
        "app.update.service.enabled" = false;
        "app.update.download.promptMaxAttempts" = 0;
        "app.update.elevation.promptMaxAttempts" = 0;
        # HTTPs only.
        "dom.security.https_only_mode" = false;
        "dom.security.https_only_mode_ever_enabled" = false;
        # Privacy and fingerprinting.
        "privacy.trackingprotection.enabled" = false;
        "privacy.trackingprotection.socialtracking.enabled" = false;
        "privacy.userContext.enabled" = false;
        # Disable Pocket.
        "extensions.pocket.enabled" = false;
        # Recently used order for tab cycles.
        "browser.ctrlTab.recentlyUsedOrder" = true;
        # Catch fat fingered quits.
        "browser.sessionstore.warnOnQuit" = true;
        # Compact UI.
        "browser.uidensity" = 1;
        # Hide warnings when playing with config.
        "browser.aboutConfig.showWarning" = false;
        # Plain new tabs.
        "browser.newtabpage.enabled" = false;
        # when you open a link image or media in a new tab switch to it immediately
        "browser.tabs.loadInBackground" = true;
        # Locale.
        "browser.search.region" = "US";
        # Don't save passwords or try to fill forms.
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        # Tell Firefox not to trust fake Enterprise-injected certificates.
        "security.enterprise_roots.auto-enabled" = false;
        "security.enterprise_roots.enabled" = false;
        "privacy.resistFingerprinting.block_mozAddonManager" = true;
        "extensions.webextensions.restrictedDomains" = "";
      };
    };
  };

  # home.file.".config/tridactyl/themes/eink.css".source = ./tridactyl.css;
}
