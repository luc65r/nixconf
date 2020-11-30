{ host, lib, ... }:

{
  home = {
    keyboard = {
      layout = "fr";
      variant = host.keymap;
      options = lib.mkIf (host.keymap == "bepo") [
        "ctrl:swapcaps"
      ];
    };
  };
}
