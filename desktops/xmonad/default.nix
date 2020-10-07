{ ... }:

{
  services.xserver.displayManager.session = [
    {
      manage = "window";
      name = "xmonad";
      start = "~/.xsession";
    }
  ];
}
