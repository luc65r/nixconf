{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      iosevka
      material-design-icons
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka" ];
        emoji = [ "Material Design Icons" ];
      };
    };
  };
}
