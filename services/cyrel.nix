{ pkgs, secrets, ... }:

let
  home = "/var/cyrel";
in {
  systemd.services.cyrel = {
    description = "cyrel functions";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    preStart = ''
      ln -sf "${secrets.cyrel.secrets}" "${home}/secrets.yaml"
      ln -sf "${secrets.cyrel.firebase}" "${home}/cyrel-pau-firebase-adminsdk-qwp1n-8e50cc74e8.json"
    '';

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${pkgs.cyrel}/bin/cyrel-functions";
      User = "cyrel";
      WorkingDirectory = home;
    };
  };

  users.users.cyrel = {
    isSystemUser = true;
    createHome = true;
    inherit home;
  };

  services.nginx.virtualHosts."cyrel.ransan.tk" = {
    enableACME = true;
    addSSL = true;
    locations."/".proxyPass = "http://localhost:8040";
  };
}
