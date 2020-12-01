{ host, ... }:

{
  imports = [
    (./. + "/${host.wm}/home.nix")
  ];

  xsession.enable = host.wm != "sway";
}
