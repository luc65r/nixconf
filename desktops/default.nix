desktop:
{ ... }:

{
  import = [
    (./. + "/${desktop}")
  ];

  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "bepo";

    libinput = {
      enable = true;
    };
  };

  home-manager.users.lucas = import ./home.nix desktop;
}
