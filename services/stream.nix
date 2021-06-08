{ pkgs, ... }:

{
  services.nginx = {
    additionalModules = [
      pkgs.nginxModules.rtmp
    ];

    virtualHosts."stream.ransan.tk" = {
      locations."/stat".extraConfig = ''
        rtmp_stat all;

        # Use this stylesheet to view XML as web page
        # in browser
        rtmp_stat_stylesheet stat.xsl;
      '';
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

  networking.firewall.allowedTCPPorts = [
    1935
  ];
}
