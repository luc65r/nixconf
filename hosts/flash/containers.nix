{ ... }:

{
  containers = {
    torrent = {
      config = import ../../containers/torrent.nix;

      ephemeral = true;
      autoStart = true;

      bindMounts = {
        "/home/transmission" = {
          hostPath = "/srv/torrent";
          isReadOnly = false;
        };

        "/srv/music" = {
          hostPath = "/srv/music";
          isReadOnly = true;
        };
      };
    };

    ftp = {
      config = import ../../containers/ftp.nix;

      ephemeral = true;
      autoStart = true;

      bindMounts = {
        "/home/test/torrent" = {
          hostPath = "/srv/torrent/Downloads";
          isReadOnly = true;
        };
      };
    };

    stream = {
      config = import ../../containers/stream.nix;

      ephemeral = true;
      autoStart = true;
    };

    navidrome = {
      config = import ../../containers/navidrome.nix;

      ephemeral = true;
      autoStart = true;

      bindMounts = {
        "/home/navidrome/music" = {
          hostPath = "/srv/music";
          isReadOnly = true;
        };

        "/home/navidrome/data" = {
          hostPath = "/srv/navidrome/data";
          isReadOnly = false;
        };
      };
    };
  };
}
