{ lib, host, ... }:

{
  imports = [
    (./. + "/${host.wm}")
  ];

  services.xserver = {
    enable = host.wm != "sway";
    layout = if host.keymap == "bepo" then "fr" else host.keymap;
    xkbVariant = lib.mkIf (host.keymap == "bepo") "bepo";
    xkbOptions = lib.mkIf (host.keymap == "bepo") "ctrl:swapcaps";

    libinput = {
      enable = true;
      naturalScrolling = lib.mkIf (host.type == "laptop") true;
      disableWhileTyping = lib.mkIf (host.type == "laptop") true;
      mouse.accelProfile = "flat";
    };
  };

  home-manager.users.lucas = import ./home.nix;
}
