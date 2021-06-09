{ config, ... }:

{
  services.prometheus = {
    enable = true;
    port = 9001;
    stateDir = "prometheus";
  };

  services.grafana = {
    enable = true;
    domain = "status.ransan.tk";
    addr = "127.0.0.1";
  };

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    enableACME = true;
    addSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };
}
