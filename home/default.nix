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
  ];

  home.packages = import ./packages.nix {
    inherit pkgs;
  };
}
