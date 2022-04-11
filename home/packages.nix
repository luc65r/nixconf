{ pkgs, lib, host }:

with pkgs;

[
  htop
  gotop
  bpytop

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
  openssl
  sshfs

  nix-prefetch-github

  zip
  unzip

  xdg-utils
] ++ lib.optionals (host.name == "sally") [
  zenmonitor
  ryzenadj

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
  lutris
  moonlight-qt
  zoom-us
]
