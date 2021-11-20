{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
  };

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
  };
}
