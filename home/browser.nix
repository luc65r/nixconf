{ pkgs, host, lib, ... }:

{
  programs.firefox = {
    enable = true;
    package = lib.mkIf (host.wm == "sway")
      (with pkgs; wrapFirefox (firefox-unwrapped.override {
        webrtcSupport = true;
        pipewireSupport = true;
      }) {
        forceWayland = true;
      });
  };
}
