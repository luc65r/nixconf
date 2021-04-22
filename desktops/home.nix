{ host, pkgs, ... }:

{
  imports = [
    (./. + "/${host.wm}/home.nix")
  ];

  xsession.enable = host.wm != "sway";

  gtk = rec {
    enable = true;
    font = {
      name = "Iosevka";
      size = 12;
    };
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    iconTheme = theme;
  };
}
