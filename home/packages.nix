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

  discord-chromium
  teams
  element-desktop
  signal-desktop

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
