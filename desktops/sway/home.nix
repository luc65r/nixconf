{ config, lib, pkgs, ... }:

let
  cfg = config.wayland.windowManager.sway;
  mod = cfg.config.modifier;

in {
  wayland.windowManager.sway = {
    enable = true;

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    config = {
      terminal = "alacritty";

      input = {
        "*" = {
          xkb_layout = "fr";
          xkb_variant = "bepo";
          xkb_options = "ctrl:swapcaps";
        };

        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "disabled";
        };

        "type:pointer" = {
          accel_profile = "flat";
          middle_emulation = "enabled";
        };
      };

      output = {
        "eDP-1" = {
          position = "0 0";
        };
        "HDMI-A-1" = {
          position = "0 -1080";
        };
      };

      modifier = "Mod4";

      keybindings = lib.mkOptionDefault {
        "${mod}+q" = "kill";
        "${mod}+d" = "exec bemenu-run -b";

        "${mod}+quotedbl" = "workspace number 1";
        "${mod}+guillemotleft" = "workspace number 2";
        "${mod}+guillemotright" = "workspace number 3";
        "${mod}+parenleft" = "workspace number 4";
        "${mod}+parenright" = "workspace number 5";
        "${mod}+at" = "workspace number 6";
        "${mod}+plus" = "workspace number 7";
        "${mod}+minus" = "workspace number 8";
        "${mod}+slash" = "workspace number 9";
        "${mod}+asterisk" = "workspace number 10";

        "${mod}+Shift+quotedbl" = "move container to workspace number 1";
        "${mod}+Shift+guillemotleft" = "move container to workspace number 2";
        "${mod}+Shift+guillemotright" = "move container to workspace number 3";
        "${mod}+Shift+parenleft" = "move container to workspace number 4";
        "${mod}+Shift+parenright" = "move container to workspace number 5";
        "${mod}+Shift+at" = "move container to workspace number 6";
        "${mod}+Shift+plus" = "move container to workspace number 7";
        "${mod}+Shift+minus" = "move container to workspace number 8";
        "${mod}+Shift+slash" = "move container to workspace number 9";
        "${mod}+Shift+asterisk" = "move container to workspace number 10";

        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";

        "XF86AudioPlay" = "exec mpc toggle";
        "XF86AudioPause" = "exec mpc toggle";
        "XF86AudioPrev" = "exec mpc prev";
        "XF86AudioNext" = "exec mpc next";

        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "Shift+Print" = "exec grim - | wl-copy";
      };

      bars = [];

      startup = [
        { command = "mako"; }
      ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        border: none;
        font-family: Iosevka, Material Design Icons;
      }

      window#waybar {
        background-color: #000000;
        color: #ffffff;
      }
    '';

    settings = [ {
      layer = "top";
      position = "top";
      height = 16;
      modules-left = [
        "sway/workspaces"
      ];
      modules-center = [];
      modules-right = [
        "battery"
        "clock"
        "tray"
      ];

      modules = {
        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };
      };
    } ];
  };

  programs.mako = {
    enable = true;
    font = "Iosevka 12";
    defaultTimeout = 5 * 1000;
    ignoreTimeout = true;
  };

  home.packages = with pkgs; [
    bemenu
    mpc_cli
    grim
    slurp
    wl-clipboard
  ];
}
