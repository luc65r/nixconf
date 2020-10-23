{ ... }:

{
  imports = [
    ../../modules/xmobar.nix
  ];

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };

  services.xmobar = {
    enable = true;
  };
}
