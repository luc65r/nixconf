{ server ? "X"
, desktop
, host
}@args:

{ lib, ... }:

{
  imports = [
    (./. + "/${desktop}")
  ];

  services.xserver = {
    enable = server == "X";
    layout = if host == "flash" then "be" else "fr";
    xkbVariant = lib.mkIf (host != "flash") "bepo";
    xkbOptions = lib.mkIf (host != "flash") "ctrl:swapcaps";

    libinput = {
      enable = true;
      naturalScrolling = lib.mkIf (host != "flash") true;
      disableWhileTyping = lib.mkIf (host != "flash") true;
      accelProfile = lib.mkIf (host == "flash") "flat";
    };
  };

  home-manager.users.lucas = import ./home.nix args;
}
