{ host, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
  };

  services.postgresqlBackup = {
    enable = host.type == "server";
    backupAll = true;
  };
}
