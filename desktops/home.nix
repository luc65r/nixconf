{ server ? "X"
, desktop
}:

{ ... }:

{
  imports = [
    (./. + "/${desktop}/home.nix")
  ];

  xsession.enable = server == "X";
}
