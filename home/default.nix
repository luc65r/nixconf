host:
{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./editor.nix
    ./shell.nix
    ./editor.nix
    ./rofi.nix
    ./font.nix
    ./terminal.nix
    ./locale.nix
    ./browser.nix
    ./video.nix
    ./music.nix
  ];

  home.packages = import ./packages.nix {
    inherit pkgs;
  };

  services.syncthing.enable = true;
}
