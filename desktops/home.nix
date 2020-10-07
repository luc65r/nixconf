desktop:
{ ... }:

{
  imports = [
    (./. + "/${desktop}/home.nix")
  ];

  xsession.enable = true;
}
