{ pkgs, host, ... }:

{
  imports = [
    ./git.nix
    ./editor.nix
    ./shell.nix
    ./editor.nix
    ./rofi.nix
    ./font.nix
    ./terminal.nix
    ./locale.nix
    ./browser.nix
    ./video.nix
    ./music.nix
    ./ssh.nix
    ./email.nix
  ];

  home.packages = import ./packages.nix {
    inherit pkgs host;
  };

  services.syncthing.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
  };

  home.stateVersion = "21.05";
}
