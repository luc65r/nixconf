{ pkgs, ... }:

{
  users.users.acme.uid = 999;

  security.acme = {
    acceptTerms = true;
    email = "lucas@ransan.tk";
  };

  services.nginx = {
    enable = true;

    package = (pkgs.nginxStable.override {
      modules = [ pkgs.nginxModules.rtmp ];
    });

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "cyrel.ransan.tk" = {
        enableACME = true;
        addSSL = true;
        locations."/".proxyPass = "http://localhost:8040";
      };

      "stream.ransan.tk" = {
        locations."/stat".extraConfig = ''
          rtmp_stat all;

          # Use this stylesheet to view XML as web page
          # in browser
          rtmp_stat_stylesheet stat.xsl;
        '';
      };
    };

    appendConfig = ''
      rtmp {
        server {
          listen 1935;
          chunk_size 4096;
          application live {
            live on;
          }
        }
      }
    '';
  };
}
