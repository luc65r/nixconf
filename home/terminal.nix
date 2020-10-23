{ ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      cursor.style = "Beam";
      window.padding = { x = 5; y = 5; };
      font = {
        size = 8;
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
    };
  };
}
