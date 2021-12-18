{ pkgs, ... }:

{
  home.packages = with pkgs; [
    river
    fuzzel
    alacritty
    kanshi
    yambar
  ];
}
