{
  inputs,
  pkgs,
  lib,
  userSetting,
  ...
}: let
  colorScheme = inputs.nix-colors.colorschemes.${userSetting.colorscheme};
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta.override {
      nativeMessagingHosts = [
        pkgs.tridactyl-native
        # pkgs.passff-host
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
      DefaultDownloadDirectory = "\${home}/Downloads";
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
      BlockAboutAddons = false;
      DisableFormHistory = true;
      AppAutoUpdate = false;
      DisableAppUpdate = true;
    };

    # https://github.com/jonhoo/configs

    # #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
    #   display: none;
    # }

    profiles.firefox = {
      # userChrome = ''

      #   @-moz-document url(chrome://browser/content/browser.xhtml) {
      #   	/* tabs on bottom of window */
      #   	/* requires that you set
      #   	 * toolkit.legacyUserProfileCustomizations.stylesheets = true
      #   	 * in about:config
      #   	 * figure out current firefox's profile folder in about:support
      #   	 */
      #       :root[tabsintitlebar] #titlebar:-moz-window-inactive { opacity: 1 !important; }
      #   	#main-window body { flex-direction: column-reverse !important; }
      #   	#navigator-toolbox { flex-direction: column-reverse !important; }
      #   	#urlbar {
      #   		top: unset !important;
      #   		bottom: calc(var(--urlbar-margin-inline)) !important;
      #   		box-shadow: none !important;
      #   		display: flex !important;
      #   		flex-direction: column !important;
      #   	}
      #   		#urlbar > * {
      #   			flex: none;
      #   		}
      #   	#urlbar .urlbar-input-container {
      #   		order: 2;
      #   	}
      #   	#urlbar > .urlbarView {
      #   		order: 1;
      #   		border-bottom: 1px solid #666;
      #   	}
      #   	#urlbar-results {
      #   		display: flex;
      #   		flex-direction: column-reverse;
      #   	}
      #   	.search-one-offs { display: none !important; }
      #   	.tab-background { border-top: none !important; }
      #   	#navigator-toolbox::after { border: none; }
      #   	#TabsToolbar .tabbrowser-arrowscrollbox,
      #   	#tabbrowser-tabs, .tab-stack { min-height: 28px !important; }
      #   	.tabbrowser-tab { font-size: 80%; }
      #   	.tab-content { padding: 0 5px; }
      #   	.tab-close-button .toolbarbutton-icon { width: 12px !important; height: 12px !important; }
      #   	toolbox[inFullscreen=true] { display: none; }
      #   	/*
      #   	 * the following makes it so that the on-click panels in the nav-bar
      #   	 * extend upwards, not downwards. some of them are in the #mainPopupSet
      #   	 * (hamburger + unified extensions), and the rest are in
      #   	 * #navigator-toolbox. They all end up with an incorrectly-measured
      #   	 * max-height (based on the distance to the _bottom_ of the screen), so
      #   	 * we correct that. The ones in #navigator-toolbox then adjust their
      #   	 * positioning automatically, so we can just set max-height. The ones
      #   	 * in #mainPopupSet do _not_, and so we need to give them a
      #   	 * negative margin-top to offset them *and* a fixed height so their
      #   	 * bottoms align with the nav-bar. We also calc to ensure they don't
      #   	 * end up overlapping with the nav-bar itself. The last bit around
      #   	 * cui-widget-panelview is needed because "new"-style panels (those
      #   	 * using "unified" panels) don't get flex by default, which results in
      #   	 * them being the wrong height.
      #   	 *
      #   	 * Oh, yeah, and the popup-notification-panel (like biometrics prompts)
      #   	 * of course follows different rules again, and needs its own special
      #   	 * rule.
      #   	 */
      #   	#mainPopupSet panel.panel-no-padding { margin-top: calc(-50vh + 40px) !important; }
      #   	#mainPopupSet .panel-viewstack, #mainPopupSet popupnotification { max-height: 50vh !important; height: 50vh; }
      #   	#mainPopupSet panel.panel-no-padding.popup-notification-panel { margin-top: calc(-50vh - 35px) !important; }
      #   	#navigator-toolbox .panel-viewstack { max-height: 75vh !important; }
      #   	panelview.cui-widget-panelview { flex: 1; }
      #   	panelview.cui-widget-panelview > vbox { flex: 1; min-height: 50vh; }
      #     #statuspanel { display: none !important; }
      #     #navigator-toolbox[fullscreenShouldAnimate] {
      #         transition: none !important;
      #     }}
      #   }
      # '';

      userChrome = ''
        @-moz-document url(chrome://browser/content/browser.xhtml) {
            /* ########  Sidetabs Styles  ######### */
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
            }}

      '';

      # #sidebar-header {
      # 	display: none !important;
      # }
      # #TabsToolbar {
      # 	display: none !important;
      # }

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        tridactyl
        old-reddit-redirect
        # ublock-origin
        istilldontcareaboutcookies
        keepassxc-browser
        sponsorblock
      ];

      # userContent = ''
      #   /* Hide scrollbar in FF Quantum */
      #   *{scrollbar-width:none !important}

      #   @-moz-document url(about:home), url(about:newtab) {
      #     body {
      #       --newtab-background-color: ${colorScheme.palette.base00};
      #       --newtab-element-hover-color: ${colorScheme.palette.base01};
      #       --newtab-icon-primary-color: ${colorScheme.palette.base04};
      #       --newtab-search-border-color: ${colorScheme.palette.base01};
      #       --newtab-search-dropdown-color: ${colorScheme.palette.base00};
      #       --newtab-search-dropdown-header-color: ${colorScheme.palette.base00};
      #       --newtab-search-icon-color: ${colorScheme.palette.base04};
      #       --newtab-section-header-text-color: ${colorScheme.palette.base05};
      #       --newtab-snippets-background-color: ${colorScheme.palette.base01};
      #       --newtab-text-primary-color: ${colorScheme.palette.base05};
      #       --newtab-textbox-background-color: ${colorScheme.palette.base01};
      #       --newtab-textbox-border: ${colorScheme.palette.base01};
      #       --newtab-topsites-background-color: ${colorScheme.palette.base04};
      #       --newtab-topsites-label-color: ${colorScheme.palette.base05};
      #       --darkreader-neutral-background: #${colorScheme.palette.base00} !important;
      #       --darkreader-neutral-text: #${colorScheme.palette.base05} !important;
      #       --darkreader-selection-background: #${colorScheme.palette.base01} !important;
      #       --darkreader-selection-text: #${colorScheme.palette.base05} !important;
      #     }
      #   }
      # '';
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
        "widget.non-native-theme.scrollbar.style" = 3;
        "ui.key.menuAccessKeyFocuses" = false;
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

  home.file.".config/tridactyl/themes/mysupertheme.css".source = ./tridactyl.css;

  xdg.configFile."tridactyl/tridactylrc".text = ''
    js tri.config.set("editorcmd", "alacritty -e hx")
  '';
}
