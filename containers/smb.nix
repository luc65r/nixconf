{ ... }:

{
  services.samba = {
    enable = true;
    shares = {
      torrent = {
        path = "/srv/torrent/Downloads";
        browsable = true;
        "read only" = true;
        "guest ok" = true;
      };
    };
  };
}
