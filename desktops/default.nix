desktop:
{ ... }:

{
  imports = [
    (./. + "/${desktop}")
  ];

  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "bepo";
    xkbOptions = "ctrl:swapcaps";

    libinput = {
      enable = true;
      naturalScrolling = true;
    };
  };

  home-manager.users.lucas = import ./home.nix desktop;
}
