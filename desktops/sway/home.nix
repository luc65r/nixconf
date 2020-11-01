{ ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      input = {
        "*" = {
          xkb_layout = "fr";
          xkb_variant = "bepo";
          xkb_options = "ctrl:swapcaps";
        };
      };

      modifier = "Mod4";
    };
  };
}
