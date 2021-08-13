{ pkgs, ... }:

{
  home.packages = with pkgs; [
    virt-manager
    pavucontrol
    transmission-remote-gtk
    bottles
  ];
}
