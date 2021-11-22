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
