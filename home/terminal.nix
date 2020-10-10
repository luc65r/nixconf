{ ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      cursor.style = "Beam";
      window.padding = { x = 5; y = 5; };
      font = {
        size = 10;
      };
    };
  };
}
