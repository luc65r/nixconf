{ ... }:

let
  nordTheme = import ../colorthemes/nord.nix;
  nord = builtins.elemAt nordTheme.palette;
in {
  programs.alacritty = {
    enable = true;

    settings = {
      live_config_reload = false;
      cursor.style = "Beam";
      window.padding = { x = 5; y = 5; };
      font = {
        size = 12;
        normal = {
          family = "Iosevka";
          style = "Regular";
        };
        bold = {
          family = "Iosevka";
          style = "Bold";
        };
        italic = {
          family = "Iosevka";
          style = "Italic";
        };
        bold_italic = {
          family = "Iosevka";
          style = "Bold Italic";
        };
      };
      colors = rec {
        primary = {
          background = nord 0;
          foreground = nord 4;
          dim_foreground = "#a5abb6";
        };
        cursor = {
          text = nord 0;
          cursor = nord 4;
        };
        vi_mode_cursor = cursor;
        selection = {
          text = "CellForeground";
          background = nord 3;
        };
        search = {
          matches = {
            foreground = "CellBackground";
            background = nord 8;
          };
          bar = {
            background = nord 2;
            foreground = nord 4;
          };
        };
        normal = {
          black = nord 1;
          red = nord 11;
          green = nord 14;
          yellow = nord 13;
          blue = nord 9;
          magenta = nord 15;
          cyan = nord 8;
          white = nord 5;
        };
        bright = {
          black = nord 3;
          red = nord 11;
          green = nord 14;
          yellow = nord 13;
          blue = nord 9;
          magenta = nord 15;
          cyan = nord 7;
          white = nord 6;
        };
        dim = {
          black = "#373e4d";
          red = "#94545d";
          green = "#809575";
          yellow = "#b29e75";
          blue = "#68809a";
          magenta = "#8c738c";
          cyan = "#6d96a5";
          white = "#aeb3bb";
        };
      };
    };
  };
}
