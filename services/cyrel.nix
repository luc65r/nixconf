{ pkgs, ... }:

{
  systemd.services.cyrel = {
    description = "Cyrel";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

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
