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
    enableNixDirenvIntegration = true;
  };

  home.stateVersion = "21.03";
}
