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
  };
}
