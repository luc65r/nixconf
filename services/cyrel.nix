{ pkgs, secrets, ... }:

let
  cyrel_env = with secrets.cyrel; {
    CELCAT_USERNAME = celcat.username;
    CELCAT_PASSWORD = celcat.password;
    JWT_SECRET = jwt.secret;
    DATABASE_URL = "postgres://cyrel@localhost/cyrel";
  };
in {
  systemd.services.cyrel = {
    description = "Cyrel";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = cyrel_env;

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${pkgs.cyrel}/bin/cyrel";
      User = "cyrel";
      WorkingDirectory = "/srv/cyrel";
    };
  };

  systemd.services.cyrel-sync = {
    description = "Cyrel Sync";

    environment = cyrel_env;

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.cyrel}/bin/cyrel-sync";
      User = "cyrel";
      WorkingDirectory = "/srv/cyrel";
    };
  };

  systemd.timers.cyrel-sync = {
    description = "Cyrel Sync timer";
    wantedBy = [ "timers.target" ];
    partOf = [ "cyrel-sync.service" ];
    timerConfig.OnCalendar = "hourly";
  };

  users.users.cyrel = {
    isSystemUser = true;
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "cyrel";
        ensurePermissions = {
          "DATABASE cyrel" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [
      "cyrel"
    ];
  };
}
