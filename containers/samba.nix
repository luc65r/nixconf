{ ... }:

{
  services.samba = {
    enable = true;
    shares = {
      torrent = {
        path = "/srv/torrent";
        "read only" = "yes";
        public = "yes";
      };
    };
  };
}
