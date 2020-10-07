desktop:
{ ... }:

{
  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "bepo";
  };

  home-manager.users.lucas = import ./home.nix desktop;
}
