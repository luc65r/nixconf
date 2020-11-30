{ server ? "X"
, desktop
, host
}:

{ ... }:

{
  imports = [
    (./. + "/${desktop}/home.nix")
  ];

  xsession.enable = server == "X";
}
