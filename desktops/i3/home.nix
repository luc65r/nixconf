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

        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioPause" = "exec mpc toggle";
        "XF86AudioPrev" = "exec mpc prev";
        "XF86AudioNext" = "exec mpc next";
      };

      bars = [];
    };
  };

  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
      mpdSupport = true;
    };

    config = {
      "bar/top" = {
        bottom = false;
        modules-left = "i3";
        modules-center = "mpd";
        modules-right = "volume date";
        tray-position = "right";
      };

      "module/i3" = {
        type = "internal/i3";
      };

      "module/date" = {
        type = "internal/date";
      };

      "module/volume" = {
        type = "internal/volume";
      };

      "module/mpd" = {
        type = "internal/mpd";
        host = "127.0.0.1";
        port = "6600";
      };
    };

    script = "polybar top &";
  };

  home.packages = with pkgs; [
    rofi
  ];
}
