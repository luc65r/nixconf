{ ... }:

{
  services.samba = {
    enable = true;
    extraConfig = ''
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      torrent = {
        path = "/srv/torrent/Downloads";
        browsable = true;
        "read only" = true;
        "guest ok" = true;
        "public" = true;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 445 139 ];
    allowedUDPPorts = [ 137 138 ];
  };
}
