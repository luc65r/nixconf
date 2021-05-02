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

    irc = {
      config = import ../../containers/irc.nix;

      ephemeral = true;
      autoStart = true;

      bindMounts = {
        "/var/lib/znc" = {
          hostPath = "/srv/znc";
          isReadOnly = false;
        };
      };
    };

    smb = {
      config = import ../../containers/smb.nix;

      ephemeral = true;
      autoStart = true;

      bindMounts = {
        "/srv/torrent/Downloads" = {
          hostPath = "/srv/torrent/Downloads";
          isReadOnly = true;
        };
      };
    };

    tracker = {
      config = import ../../containers/tracker.nix;

      ephemeral = true;
      autoStart = true;
    };
  };
}
