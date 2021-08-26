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
    (sublime-music.overrideAttrs (old: rec {
      version = "0.11.13";
      src = pkgs.fetchFromGitLab {
        owner = "sublime-music";
        repo = "sublime-music";
        rev = "v0.11.13";
        sha256 = "NzbQtRcsRVppyuG1UuS3IidSnniUOavf5YoAf/kcZqw=";
      };
    }))
  ];
}
