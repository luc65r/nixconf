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

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };

  xdg.mimeApps.defaultApplications = lib.attrsets.genAttrs [
    "default-web-browser"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/chrome"
    "text/html"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/xhtml+xml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
  ] (_: [
    "firefox.desktop"
    "chromium-browser.desktop"
  ]);
}
