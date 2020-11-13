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
        };
      };

      modifier = "Mod4";

      keybindings = lib.mkOptionDefault {
        "${mod}+q" = "kill";
        "${mod}+d" = "exec bemenu-run";

        "${mod}+quotedbl" = "workspace number 1";
        "${mod}+guillemotleft" = "workspace number 2";
        "${mod}+guillemotright" = "workspace number 3";
        "${mod}+parenleft" = "workspace number 4";
        "${mod}+parenright" = "workspace number 5";
        "${mod}+at" = "workspace number 6";
        "${mod}+plus" = "workspace number 7";
        "${mod}+minus" = "workspace number 8";
        "${mod}+slash" = "workspace number 9";

        "${mod}+Shift+quotedbl" = "move container to workspace number 1";
        "${mod}+Shift+guillemotleft" = "move container to workspace number 2";
        "${mod}+Shift+guillemotright" = "move container to workspace number 3";
        "${mod}+Shift+parenleft" = "move container to workspace number 4";
        "${mod}+Shift+parenright" = "move container to workspace number 5";
        "${mod}+Shift+at" = "move container to workspace number 6";
        "${mod}+Shift+plus" = "move container to workspace number 7";
        "${mod}+Shift+minus" = "move container to workspace number 8";
        "${mod}+Shift+slash" = "move container to workspace number 9";
      };

      bars = [];
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    bemenu
  ];
}
