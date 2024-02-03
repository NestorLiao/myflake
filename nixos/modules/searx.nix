{...}: {
  programs.command-not-found.enable = false;

  services.searx = {
    enable = true;
    settings = {
      categories_as_tabs = {
        general = {};
        dev = {};
        science = {};
      };
      use_default_settings = {
        engines = {
          keep_only = [
            "github"
            "brave"
            "google"
            "duckduckgo"
            "stackexchange"
            # "wikipedia"
          ];
        };
      };

      engines = [
        {
          name = "google";
          engine = "google";
          weight = 1;
          use_mobile_ui = true;
          shortcut = "go";
          disabled = true;
        }
        # {
        #   name = "crowdview";
        #   engine = "json_engine";
        #   shortcut = "cv";
        #   categories = "general";
        #   paging = false;
        #   search_url = "https://crowdview-next-js.onrender.com/api/search-v3?query={query}";
        #   results_query = "results";
        #   url_query = "link";
        #   title_query = "title";
        #   weight = 0.3;
        #   content_query = "snippet";
        #   disabled = false;
        #   about = {
        #     website = "https://crowdview.ai/";
        #   };
        # }
        {
          name = "mwmbl";
          engine = "mwmbl";
          # api_url = "https://api.mwmbl.org";
          shortcut = "mwm";
          weight = 0.3;
          categories = "general";
          disabled = false;
        }

        {
          name = "mankier";
          engine = "json_engine";
          search_url = "https://www.mankier.com/api/v2/mans/?q={query}";
          results_query = "results";
          url_query = "url";
          title_query = "name";
          content_query = "description";
          categories = "dev";
          disabled = false;
          shortcut = "man";
          about = {
            website = "https://www.mankier.com/";
            official_api_documentation = "https://www.mankier.com/api";
            use_official_api = true;
            require_api_key = false;
            results = "JSON";
          };
        }
        {
          name = "brave";
          engine = "brave";
          shortcut = "br";
          weight = 0.6;
          disabled = false;
        }
        # {
        #   name = "google images";
        #   engine = "google_images";
        #   weight = 0.6;
        #   shortcut = "goi";
        # }
        {
          name = "pypi";
          shortcut = "pip";
          engine = "xpath";
          paging = "True";
          search_url = "https://pypi.org/search?q={query}&page={pageno}";
          results_xpath = ''/html/body/main/div/div/div/form/div/ul/li/a[@class=" package-snippet "]'';
          url_xpath = "./@href";
          title_xpath = ''./h3/span[@class=" package-snippet__name "]'';
          content_xpath = "./p";
          suggestion_xpath = ''/html/body/main/div/div/div/form/div/div[@class=" callout-block "]/p/span/a[@class=" link "]'';
          first_page_num = "1";
          categories = "dev";
          about = {
            website = "https://pypi.org";
            wikidata_id = "Q2984686";
            official_api_documentation = "https://warehouse.readthedocs.io/api-reference/index.html";
            use_official_api = false;
            require_api_key = false;
            results = "HTML";
          };
        }
        {
          name = "nixpkgs";
          shortcut = "nix";
          engine = "elasticsearch";
          categories = "dev";
          base_url = "https://nixos-search-5886075189.us-east-1.bonsaisearch.net:443";
          index = "latest-31-nixos-unstable";
          query_type = "match";
        }
        {
          name = "github";
          engine = "github";
          shortcut = "gh";
          categories = "dev";
        }
      ];
      # outgoing = {
      #   request_timeout = 15.0;
      #   max_request_timeout = 30.0;
      # };

      general = {
        instance_name = "Search";
        debug = false;
        privacypolicy_url = false;
        donation_url = false;
        contact_url = false;
        enable_metrics = true;
      };
      ui = {
        query_in_title = true;
        results_on_new_tab = false;
        theme_args.simple_style = "light";
        infinite_scroll = true;
      };
      search = {
        default_lang = "en-US";
        safe_search = 1;
        autocomplete = "google";
      };

      enabled_plugins = [
        "Hash plugin"
        "Self Informations"
        "Tracker URL remover"
        "Ahmia blacklist"
      ];

      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "secret key";
        default_locale = "en";
        default_theme = "simple";
        method = "GET";
      };
    };
  };
}
