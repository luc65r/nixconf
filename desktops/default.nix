{ server ? "X"
, desktop
}@args:

{ lib, ... }:

{
  imports = [
    (./. + "/${desktop}")
  ];

  services.xserver = {
    enable = server == "X";
    layout = "fr";
    xkbVariant = "bepo";
    xkbOptions = "ctrl:swapcaps";

    libinput = {
      enable = true;
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };

  home-manager.users.lucas = import ./home.nix args;
}
