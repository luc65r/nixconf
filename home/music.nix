{ host, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = if (host.name == "flash")
      then "/srv/music" else "/home/lucas/Musique";

    extraConfig = ''
      audio_output {
        type "pulse"
        name "pulse audio"
      }
    '';
  };

  programs.ncmpcpp = {
    enable = true;
  };

  home.packages = with pkgs; [
    mpc_cli
    sublime-music
  ];
}
