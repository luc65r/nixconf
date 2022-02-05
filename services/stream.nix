{ pkgs, ... }:

let
  dash_server_py = pkgs.fetchurl {
    url = "https://gitlab.com/fflabs/dash_server/-/raw/b87b3ca2937fa4b24f8fc1627bdacad6194dcd59/dash_server.py";
    hash = "sha256-UGnIrWJBDyb+dVqeMPtfT5Hhzx/LekbTXF0uo0JEWoE=";
  };
  dash_server_py_port = 8000;

in {
  services.nginx = {
    upstreams."dash_server_py".servers = {
      "127.0.0.1:${toString dash_server_py_port}" = {};
    };

    virtualHosts."stream.ransan.tk" = {
      enableACME = true;
      addSSL = true;

      root = ./stream;

      locations."/utc_timestamp" = {
        return = "200 \"$time_iso8601\"";
        extraConfig = ''
          default_type text/plain;
        '';
      };
      locations."/live/".tryFiles = "$uri @dash_server";
      locations."@dash_server".proxyPass = "http://dash_server_py";

      extraConfig = ''
        proxy_http_version        1.1;
        proxy_buffering           off;
        proxy_request_buffering   off;
        proxy_ignore_client_abort on;
      '';
    };

    virtualHosts."instream.ransan.tk" = {
      listen = [
        { addr = "127.0.0.1"; port = 8001; ssl = true; }
      ];

      enableACME = true;
      addSSL = true;

      extraConfig = ''
        #ssl_client_certificate "<path to CA for client certs>";
        #ssl_verify_client on;

        if ($request_method !~ ^(POST|PUT|DELETE)$) {
            return 405;
        }

        proxy_http_version        1.1;
        proxy_buffering           off;
        proxy_request_buffering   off;
        proxy_ignore_client_abort on;
      '';

      locations."/live/".proxyPass = "http://dash_server_py";
    };
  };

  systemd.services.dash_server_py = {
    description = "dash_server.py";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${pkgs.python3} ${dash_server_py} -p ${toString dash_server_py_port}";
    };
  };
}
