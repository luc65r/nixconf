{ pkgs, ... }:

{
  home.packages = with pkgs; [
    river
  ];
}
