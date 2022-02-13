{ host, pkgs, ... }:

{
  imports = [
    (./. + "/${host.wm}/home.nix")
  ];

  gtk = {
    enable = true;
    font = {
      name = "Iosevka";
      size = 12;
    };
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
  };
}
