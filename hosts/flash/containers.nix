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

    samba = {
      config = import ../../containers/samba.nix;

      ephemeral = true;
      autoStart = true;

      bindMounts = {
        "/srv/torrent" = {
          hostPath = "/srv/torrent/Downloads";
          isReadOnly = true;
        };
      };
    };
  };
}
