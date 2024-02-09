{
  pkgs,
  inputs,
  ...
}: let
  # kinda annoying but it'll have to do
  # TODO: make sure to keep it updated for now
  typst-ts-rev = "791cac478226e3e78809b67ff856010bde709594";
in {
  # copy queries folder according to instructions
  # https://github.com/uben0/tree-sitter-typst/tree/master#helix
  xdg.configFile."helix/runtime/queries/typst" = let
    repo = builtins.fetchGit {
      url = "https://github.com/uben0/tree-sitter-typst";
      rev = typst-ts-rev;
    };
  in {
    source = "${repo}/queries";
  };
  programs.helix = {
    package = inputs.helix.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      alejandra
      clang-tools
      # formatting
      lua-language-server
      marksman # Markdown
      nil # Nix
      nodePackages.bash-language-server
      nodePackages.prettier
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      nodePackages.yaml-language-server
      rust-analyzer-unwrapped
      taplo
      typst-lsp
    ];
    settings = {
      theme = "eink";
      # theme = "emacs";
      keys = {
        normal = {
          esc = ["collapse_selection" "keep_primary_selection"];
          "C-h" = ":open ~/nink/nixos";
          "C-e" = ":open ~/nink/inklife";
          "C-p" = ":open ~/playground/snippet";
          "\\" = ":reload-all";
          "X" = ["extend_line_up" "extend_to_line_bounds"];
          "A-x" = "extend_to_line_bounds";
          "g" = {"a" = "code_action";};
          "A-s" = ":sh sudo nixos-rebuild switch --show-trace";
          "ret" = ["open_below" "normal_mode"];
          "A-ret" = ["open_above" "normal_mode"];
        };
        select = {"X" = ["extend_line_up" "extend_to_line_bounds"];};
        select.space = {
          "f" = "file_picker_in_current_directory";
          "F" = "file_picker";
          "space" = ":buffer-previous";

          "e" = ["page_down" "goto_window_center"];
          "i" = ["page_up" "goto_window_center"];
          "q" = ":quit!";
          "r" = ":write";
          "n" = ":buffer-close";
          "t" = ["yank_to_clipboard" ":sh ts  2>&1 || true"];
          "o" = "file_picker_in_current_buffer_directory";
          "ret" = ":hsplit-new";
          "backspace" = ":buffer-close!";
        };
        normal.space = {
          "f" = "file_picker_in_current_directory";
          "F" = "file_picker";
          "space" = ":buffer-previous";

          "e" = ["page_down" "goto_window_center"];
          "i" = ["page_up" "goto_window_center"];
          "q" = ":quit!";
          "r" = ":write";
          "n" = ":buffer-close";
          "t" = ["yank_to_clipboard" ":sh ts  2>&1 || true"];
          "o" = "file_picker_in_current_buffer_directory";
          "ret" = ":hsplit-new";
          "backspace" = ":buffer-close!";
          # r write-rite-r
          # t translate-t
          # n close-buffer_no need this buffer
          # e pagedown-mybroswerlike
          # i pageup-mybroswerlike
          # o open file in buffer dir-open
        };
        normal.backspace = {
          "backspace" = ":buffer-next";
          "z" = ":bco";
          "r" = [":write" ":sh ./key.sh 1 2>&1 || true"];
          "t" = [":write" ":sh ./key.sh 2 2>&1 || true"];
          "n" = [":write" ":sh ./key.sh 3 2>&1 || true"];
          "e" = [":write" ":sh ./key.sh 4 2>&1 || true"];
          "i" = [":write" ":sh ./key.sh 5 2>&1 || true"];
          "o" = [":write" ":sh ./key.sh 6 2>&1 || true"];
          "l" = [":write" ":sh ./key.sh 6 2>&1 || true"];
        };
        normal."]" = {
          "]" = "goto_next_paragraph";
        };
        normal."[" = {
          "[" = "goto_prev_paragraph";
        };
      };

      editor = {
        lsp = {
          display-messages = true;
          auto-signature-help = false; # https://github.com/helix-editor/helix/discussions/6710
        };
        gutters = ["diagnostics" "spacer" "diff"];
        bufferline = "multiple";
        auto-info = true;
        auto-save = true;
        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "diagnostics"
            "position-percentage"
            "position"
            "version-control"
          ];
          right = [
          ];
          mode = {
            normal = "修";
            insert = "入";
            select = "选";
          };
        };
        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          "\"" = ''"'';
          "`" = "`";
        };
        soft-wrap = {
          enable = false;
          max-wrap = 25;
          max-indent-retain = 0;
          wrap-indicator = "";
        };
        indent-guides = {
          render = false;
          character = "╎";
          skip-levels = 1;
        };
        # line-number = "relative";
        mouse = true;
        # mouse = false;
        scrolloff = 0;
      };
    };
    enable = true;
    defaultEditor = true;
    languages = {
      grammar = [
        {
          name = "typst";
          source = {
            git = "https://github.com/uben0/tree-sitter-typst";
            rev = typst-ts-rev;
          };
        }
      ];
      language = [
        {
          name = "nix";
          formatter.command = "alejandra";
          auto-format = true;
          indent = {
            tab-width = 8;
            unit = "t";
          };
        }
        {
          name = "markdown";
          formatter = {
            command = "prettier";
            args = ["--parser" "markdown"];
          };
          auto-format = false;
        }
        {
          name = "javascript";
          formatter = {
            command = "prettier";
            args = ["--parser" "javascript"];
          };
          auto-format = true;
        }
        {
          name = "typescript";
          formatter = {
            command = "prettier";
            args = ["--parser" "typescript"];
          };
          auto-format = true;
        }
        {
          name = "html";
          formatter = {
            command = "prettier";
            args = ["--parser" "html"];
          };
        }
        {
          name = "css";
          formatter = {
            command = "prettier";
            args = ["--parser" "css"];
          };
          auto-format = true;
        }
        {
          name = "json";
          formatter = {
            command = "prettier";
            args = ["--parser" "json"];
          };
          auto-format = true;
        }
        {
          name = "yaml";
          formatter = {
            command = "prettier";
            args = ["--parser" "yaml"];
          };
          auto-format = true;
        }
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "c";
          auto-format = true;
          language-servers = ["clangd"];
          formatter = {command = "clang-format";};
          indent = {
            tab-width = 8;
            unit = "t";
          };
        }
        {
          name = "typst";
          scope = "source.typst";
          injection-regex = "^typ(st)?$";
          file-types = ["typ"];
          comment-token = "//";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          auto-pairs = {
            "(" = ")";
            "{" = "}";
            "[" = "]";
            "\"" = "\"";
            "`" = "`";
            "$" = "$";
          };
          roots = ["typst.toml"];
          language-servers = ["typst-lsp"];
          auto-format = true;
          formatter = {
            command = "typst-fmt";
          };
        }
      ];
      language-server = {
        cmake-language-server = {
          command = "${pkgs.cmake-language-server}/bin/cmake-language-server";
        };
        rust-analyzer = {
          command = pkgs.rust-analyzer-unwrapped + /bin/rust-analyzer;
          config.check.command = "clippy";
        };
        typescript-language-server = with pkgs.nodePackages; {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = ["--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"];
        };
        bash-language-server = {
          command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
          args = ["start"];
        };
        clangd = {
          command = "clangd";
          args = ["--clang-tidy"];
        };
        vscode-css-language-server = {
          command = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";

          args = ["--stdio"];
        };

        typst-lsp = {
          command = "typst-lsp";
        };
      };
    };
    themes = {
      eink = let
        white = "#FFFFFF";
        black = "#000000";
      in {
        # line
        # curl
        # dashed
        # dotted
        # double_line

        "ui.background" = {bg = white;};
        "ui.text" = black;
        "ui.selection" = {
          bg = white;
          fg = black;
          # modifiers = ["bold"];
          underline = {
            color = black;
            style = "dashed";
          };
        };
        "ui.cursorline" = {bg = black;};
        "ui.statusline" = {
          bg = white;
          fg = black;
        };
        "ui.virtual.ruler" = {bg = black;};
        "ui.cursor.match" = {
          fg = white;
          bg = black;
        };
        "ui.cursor" = {
          fg = white;
          bg = black;
          # modifiers = ["bold"];
          underline = {
            color = white;
            style = "curl";
            # style = "dashed";
          };
        };
        "ui.cursorline.primary" = {bg = black;};
        "ui.linenr" = {fg = black;};
        "ui.linenr.selected" = {
          fg = black;
          bg = white;
        };
        "ui.menu" = {
          bg = white;
          fg = black;
        };
        "ui.menu.selected" = {bg = white;};
        "ui.popup" = {bg = white;};
        "ui.popup.info" = {
          bg = white;
          fg = black;
        };
        "ui.help" = {
          bg = white;
          fg = black;
        };
        "ui.window" = {bg = white;};
        "ui.statusline.normal" = {
          fg = black;
          bg = white;
        };
        "ui.statusline.insert" = {
          fg = black;
          bg = white;
        };
        "ui.statusline.select" = {
          fg = black;
          bg = white;
        };
        "diagnostic.error" = {
          underline = {
            color = black;
            style = "curl";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = black;
            style = "curl";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = black;
            style = "curl";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = black;
            style = "curl";
          };
        };
        "constant.numeric" = {
          fg = black;
          modifiers = ["italic"];
        };
        "constant.builtin" = {fg = black;};
        "keyword" = {fg = black;};
        "keyword.control" = {
          fg = black;
          # modifiers = ["bold"];
        };
        "keyword.function" = {
          fg = black;
          # modifiers = ["bold"];
        };
        "function" = {fg = black;};
        "function.macro" = {
          fg = black;
          # modifiers = ["bold"];
        };
        "function.method" = {fg = black;};
        "function.builtin" = {fg = black;};
        "variable.builtin" = {fg = black;};
        "variable.other" = {fg = black;};
        "variable" = {fg = black;};
        "string" = black;
        "comment" = {
          fg = black;
          modifiers = ["italic"];
        };
        "namespace" = {fg = black;};
        "attribute" = {fg = black;};
        "type" = {
          fg = black;
          # modifiers = ["bold"];
        };
        "markup.heading" = {
          fg = black;
          modifiers = ["bold"];
        };
        "markup.raw" = {fg = black;};
        "markup.link.url" = {fg = black;};
        "markup.link.text" = {fg = black;};
        "markup.quote" = {
          fg = black;
          modifiers = ["italic"];
        };
        "markup.bold" = {
          fg = black;
          modifiers = ["bold"];
        };
        "markup.italic" = {
          fg = black;
          modifiers = ["italic"];
        };
        "markup.inline" = {
          fg = black;
          modifiers = ["italic"];
        };
        "diff.plus" = {fg = black;};
        "diff.delta" = {fg = black;};
        "diff.minus" = {fg = black;};
      };
    };
  };
}
