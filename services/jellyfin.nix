{ ... }:

{
  services.jellyfin = {
    enable = true;
  };

  services.nginx.virtualHosts."jellyfin.ransan.tk" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:8096";
  };

  networking.firewall.allowedUDPPorts = [
    1900 7359
  ];
}
