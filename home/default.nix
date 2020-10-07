host:
{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./editor.nix
    ./shell.nix
    ./editor.nix
  ];
}
