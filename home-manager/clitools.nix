{ pkgs, lib, userSetting, config, inputs, ... }: {
  imports = [ ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "adwaita";
      theme_background = false;
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      demuxer-max-back-bytes = 10000000000;
      demuxer-max-bytes = 10000000000;
      save-position-on-quit = true;
      profile = "high-quality";
      video-sync = "display-resample";
      interpolation = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.bash.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "https://github.com" ];
    };
    extensions = with pkgs; [ gh-markdown-preview ];
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "NestorLiao";
    userEmail = "gtkndcbfhr@gmail.com";
    extraConfig = {
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };

  home.file.".config/fish/functions/rcdir.fish".text = ''
    function rcdir
        while true
            read -l -P 'Do you want to continue? [y/N] ' confirm

            switch $confirm
                case Y y
                    rm -rf (pwd)
                    cd ..
                    return 0
                case \'\' N n
                    return 1
            end
        end
    end
  '';

  home.file.".config/fish/functions/mcdir.fish".text = ''
    function mcdir
    command mkdir $argv[1]
    and cd $argv[1]
    end
  '';

  home.file.".cargo/config.toml".text = ''
    [source.crates-io]
    replace-with = 'rsproxy-sparse'
    [source.rsproxy]
    registry = "https://rsproxy.cn/crates.io-index"
    [source.rsproxy-sparse]
    registry = "sparse+https://rsproxy.cn/index/"
    [registries.rsproxy]
    index = "https://rsproxy.cn/crates.io-index"
    [net]
    git-fetch-with-cli = true
  '';

  programs.command-not-found.enable = false;
}
