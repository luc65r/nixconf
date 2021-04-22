{ host, pkgs, ... }:

{
  imports = [
    (./. + "/${host.wm}/home.nix")
  ];

  xsession.enable = host.wm != "sway";

  gtk = {
    enable = true;
    font = {
      name = "Iosevka";
      size = 12;
    };
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    iconTheme = {
      package = with pkgs; stdenvNoCC.mkDerivation {
        pname = "dracula-icons";
        version = "5214870";

        src = fetchzip {
          url = "https://github.com/dracula/gtk/files/5214870/Dracula.zip";
          sha256 = "rcSKlgI3bxdh4INdebijKElqbmAfTwO+oEt6M2D1ls0=";
        };

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p $out/share/icons/Dracula
          cp -a 16 Places actions apps index.theme $out/share/icons/Dracula
        '';
      };
      name = "Dracula";
    };
  };
}
