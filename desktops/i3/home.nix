{ lib, pkgs, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      terminal = "alacritty";
      modifier = "Mod4";
      menu = "rofi -show drun";

      keybindings = lib.mkOptionDefault {
        "${modifier}+q" = "kill";
      };

      bars = [];
    };
  };

  home.packages = with pkgs; [
    rofi
  ];
}
