{ pkgs, lib, secrets, ... }:

let
  mapAttrsToListRecursive = with lib; f: set: let
    recurse = path: set: let
      g = k: v:
        if isAttrs v
        then recurse (path ++ [k]) v
        else f (path ++ [k]) v;
    in concatMap (x: if isList x then x else [x]) (mapAttrsToList g set);
  in recurse [] set;

  cyrel_env = builtins.listToAttrs
    (mapAttrsToListRecursive (k: v: {
      name = builtins.concatStringsSep "_" (map lib.toUpper k);
      value = toString v;
    }) secrets.cyrel);

  port = 3030;
in {
  systemd.services.cyrel = {
    description = "Cyrel";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = cyrel_env // {
      PORT = toString port;
    };

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${pkgs.cyrel}/bin/cyrel";
      User = "cyrel";
      WorkingDirectory = "/srv/cyrel";
    };
  };

  services.nginx.virtualHosts."cyrel.ransan.tk" = {
    enableACME = true;
    addSSL = true;
    locations."/".proxyPass = "http://localhost:${toString port}";
  };

  systemd.services.cyrel-sync-courses = {
    description = "Cyrel Sync Courses";

    environment = cyrel_env;

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.cyrel}/bin/cyrel-sync-courses";
      User = "cyrel";
      WorkingDirectory = "/srv/cyrel";
      LimitNOFILE = "65536";
    };
  };

  systemd.timers.cyrel-sync-courses = {
    description = "Cyrel Sync Courses timer";
    wantedBy = [ "timers.target" ];
    partOf = [ "cyrel-sync-courses.service" ];
    timerConfig.OnCalendar = "hourly";
  };

  systemd.services.cyrel-sync-students = {
    description = "Cyrel Sync Students";

    environment = cyrel_env;

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.cyrel}/bin/cyrel-sync-students";
      User = "cyrel";
      WorkingDirectory = "/srv/cyrel";
    };
  };

  systemd.timers.cyrel-sync-students = {
    description = "Cyrel Sync Students timer";
    wantedBy = [ "timers.target" ];
    partOf = [ "cyrel-sync-students.service" ];
    timerConfig.OnCalendar = "weekly";
  };

  users.users.cyrel = {
    isSystemUser = true;
    group = "cyrel";
  };
  users.groups.cyrel = {};

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
