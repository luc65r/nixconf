{ pkgs, host }:

with pkgs;

[
  htop
  gotop
  bpytop

  zenmonitor
  ryzenadj

  ripgrep
  fd
  jq
  exa
  bat
  tealdeer
  fzf
  skim
  bottom
  file
  dnsutils
  usbutils
  pciutils

  nix-prefetch-github

  ktouch

  (if host.wm == "sway"
   then discord-wayland
   else discord)
  teams
  element-desktop

  libreoffice-fresh
  texlive.combined.scheme-full
  aspell
  aspellDicts.fr
  aspellDicts.en

  translate-shell

  brightnessctl
  pulsemixer

  (steam.override {
    extraLibraries = pkgs: [ pkgs.pipewire ];
  })
  moonlight-qt
  zoom-us

  zip
  unzip

  xdg-utils
]
