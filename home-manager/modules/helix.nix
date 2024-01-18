{ pkgs, config, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      markdown = [{
        name = "markdown";
        file-types = [ "md" "mdx" "markdown" ];
        text-width = 80;
        soft-wrap = {
          enable = true;
          wrap-at-text-width = true;
        };
      }];
      rust = [{
        name = "rust";
        auto-format = true;
      }];
      grammar = [{
        name = "rust";
        source = {
          git = "https://github.com/tree-sitter/tree-sitter-rust";
          rev = "0431a2c60828731f27491ee9fdefe25e250ce9c9";
        };
      }];
      language-server = {
        bash-language-server = {
          command =
            "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
          args = [ "start" ];
        };
        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
          clangd.fallbackFlags = [ "-std=c++2b" ];
          auto-pairs = {
            "(" = ")";
            "{" = "}";
            "[" = "]";
            "\"" = ''"'';
            "`" = "`";
          };
        };
        vscode-css-language-server = {
          command =
            "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
          args = [ "--stdio" ];
        };
      };
    };
    settings = {
      theme = "eink";
      # theme = "papercolor-light";
      editor = {
        # gutters = ["diagnostics" "spacer" "diff"];
        auto-info = true;
        auto-save = true;
        file-picker.hidden = true;
        statusline = {
          left = [ "mode" "spinner" "file-name" 
            "diagnostics"
            "position-percentage"
            "position"
            "version-control" ];
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
          enable = true;
          max-wrap = 25;
          max-indent-retain = 0;
          wrap-indicator = "";
        };
        indent-guides = {
          render = true;
          character = "╎";
          skip-levels = 1;
        };
        lsp.display-messages = true;
        line-number = "relative";
        # mouse = true;
        mouse = false;
        scrolloff = 3;
      };
      keys = {
        normal = {
          esc=["collapse_selection" "keep_primary_selection"];
          "C-h" = ":open ~/nink/nixos";
          "C-e" = ":open ~/nink/inklife";
          "C-p" = ":open ~/playground/snippet";
          "\\" = ":reload-all";
          "X" = [ "extend_line_up" "extend_to_line_bounds" ];
          "A-x" = "extend_to_line_bounds";
          "g" = { "a" = "code_action"; };
          "A-s" = ":sh sudo nixos-rebuild switch --show-trace";
          "ret" = ["open_below" "normal_mode"];
          "A-ret" = ["open_above" "normal_mode"];
        };
        select = { "X" = [ "extend_line_up" "extend_to_line_bounds" ]; };

        select.space = {
          "e" = ":buffer-close";
          "q" = ":quit!";
          "n" = ":write";
          "space" = ":buffer-previous";
          "backspace" = ":buffer-next";
          "o" = "file_picker_in_current_buffer_directory";
          "t" = ":sh ./key.sh 1 2>&1 || true";
          "m" = ":sh ./key.sh 2 2>&1 || true";
          "r" = ":sh ./key.sh 3 2>&1 || true";
          "l" = ":sh ./key.sh 4 2>&1 || true";
          "i" = [ "yank_to_clipboard" ":sh ts  2>&1 || true"];
          "ret" =":sh tmux last-window";
        };

        normal.space = {
          "e" = ":buffer-close";
          "q" = ":quit!";
          "n" = ":write";
          "space" = ":buffer-previous";
          "backspace" = ":buffer-next";
          "o" = "file_picker_in_current_buffer_directory";
          "t" = ":sh ./key.sh 1 2>&1 || true";
          "m" = ":sh ./key.sh 2 2>&1 || true";
          "r" = ":sh ./key.sh 3 2>&1 || true";
          "l" = ":sh ./key.sh 4 2>&1 || true";
          "i" = [ "yank_to_clipboard" ":sh ts  2>&1 || true"];
          "ret" =":sh tmux last-window";
        };

        normal."tab"= {
          "n" =":sh tmux split-window -v -p 70 'cht.sh --shell'";
          "e" =":sh ";
          "i" =":sh ";
          "o" =":sh ";
          "a" =":sh ";
          "r" =":sh ";
          "s" =":sh ";
          "t" =":sh ";
        };

        normal."]"= {
          "]" ="goto_next_paragraph";
        };
        normal."["= {
          "[" ="goto_prev_paragraph";
        };
      };
    };

    themes = {
      eink = let
        white = "#FFFFFF";
        black = "#000000";
      in {
        "ui.background" = { bg = white; };
        "ui.text" = black;
        "ui.selection" = {
          bg = white;
          fg = black;
          modifiers = [ "bold" ];
          underline = {
            color = black;
            style = "curl";
          };
        };
        "ui.cursorline" = { bg = black; };
        "ui.statusline" = {
          bg = white;
          fg = black;
        };
        "ui.virtual.ruler" = { bg = black; };
        "ui.cursor.match" = { bg = black; };
        "ui.cursor" = {
          bg = black;
          fg = white;
        };
        "ui.cursorline.primary" = { bg = black; };
        "ui.linenr" = { fg = black; };
        "ui.linenr.selected" = {
          fg = black;
          bg = white;
        };
        "ui.menu" = {
          bg = white;
          fg = black;
        };
        "ui.menu.selected" = { bg = white; };
        "ui.popup" = { bg = white; };
        "ui.popup.info" = {
          bg = white;
          fg = black;
        };
        "ui.help" = {
          bg = white;
          fg = black;
        };
        "ui.window" = { bg = white; };
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
        "constant.numeric" = { fg = black; };
        "constant.builtin" = { fg = black; };
        "keyword" = { fg = black; };
        "keyword.control" = { fg = black; };
        "keyword.function" = { fg = black; };
        "function" = { fg = black; };
        "function.macro" = {
          fg = black;
          modifiers = [ "bold" ];
        };
        "function.method" = { fg = black; };
        "function.builtin" = { fg = black; };
        "variable.builtin" = { fg = black; };
        "variable.other" = { fg = black; };
        "variable" = { fg = black; };
        "string" = black;
        "comment" = {
          fg = black;
          modifiers = [ "italic" ];
        };
        "namespace" = { fg = black; };
        "attribute" = { fg = black; };
        "type" = { fg = black; };
        "markup.heading" = {
          fg = black;
          modifiers = [ "bold" ];
        };
        "markup.raw" = { fg = black; };
        "markup.link.url" = { fg = black; };
        "markup.link.text" = { fg = black; };
        "markup.quote" = {
          fg = black;
          modifiers = [ "italic" ];
        };
        "diff.plus" = { fg = black; };
        "diff.delta" = { fg = black; };
        "diff.minus" = { fg = black; };
      };
    };
  };
}
