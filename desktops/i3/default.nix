{ ... }:

{
  services.xserver.displayManager.session = [
    {
      manage = "window";
      name = "i3";
      start = "~/.xsession";
    }
  ];
}
