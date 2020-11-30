{ host, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = if (host.name == "flash")
      then "/srv/music" else "/home/lucas/Musique";
  };

  programs.ncmpcpp = {
    enable = true;
  };

  home.packages = with pkgs; [
    mpc_cli
  ];
}
