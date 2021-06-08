{ ... }:

{
  services.samba = {
    enable = true;
    enableNmbd = true;
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

  services.minidlna = {
    enable = true;
    friendlyName = "flash";
    announceInterval = 30;
    mediaDirs = [
      "V,/srv/torrent/Downloads"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [ 445 139 8200 ];
    allowedUDPPorts = [ 137 138 1900 ];
  };
}
