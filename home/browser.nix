{ pkgs, host, lib, ... }:

{
  programs.firefox = {
    enable = true;
    package = lib.mkIf (host.wm == "sway") pkgs.firefox-wayland;
  };
}
