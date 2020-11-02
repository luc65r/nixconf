host:
{ pkgs, ... }:

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
    (import ((builtins.fetchTarball {
      url = "https://github.com/nix-community/impermanence/tarball/4b3000b9bec3a3ce4d5bb7d79abfdd267b5f42ea";
      sha256 = "0gwx6ggg5gw9w9xnd5k7pq8viknjb88zxn711bqmfcnvnx74hav1";
    }) + "/home-manager.nix"))
  ];

  home.packages = import ./packages.nix {
    inherit pkgs;
  };

  services.syncthing.enable = true;

  home.persistence."/persist/home/lucas" = {
    directories = [
      "Documents"
      "nixconf"
      ".emacs.d"
      ".ssh"
      ".cache"
    ];

    files = [
      ".zsh_history"
    ];
  };
}
