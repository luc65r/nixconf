{ lib, host, ... }:

{
  imports = [
    (./. + "/${host.wm}")
  ];

  services.xserver = {
    enable = false;
    layout = if host.keymap == "bepo" then "fr" else host.keymap;
    xkbVariant = lib.mkIf (host.keymap == "bepo") "bepo";
    xkbOptions = lib.mkIf (host.keymap == "bepo") "ctrl:swapcaps";

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
      };
      mouse.accelProfile = "flat";
    };
  };

  home-manager.users.lucas = import ./home.nix;

  # Gtk-WARNING: The name org.a11y.Bus was not provided by any .serv
  #environment.variables.NO_AT_BRIDGE = "1";
}
