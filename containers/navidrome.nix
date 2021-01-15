{ pkgs, ... }:

let
  home = "/home/navidrome";
  configFile = (pkgs.formats.toml {}).generate "navidrome.toml" {
    MusicFolder = "${home}/music";
    DataFolder = "${home}/data";
  };

in {
  security.pam.loginLimits = [
    { # too many open files
      domain = "navidrome";
      item = "nofile";
      type = "soft";
      value = "8196";
    }
  ];

  systemd.services.navidrome = {
    description = "Navidrome";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.navidrome}/bin/navidrome --configfile ${configFile}
      '';
      WorkingDirectory = home;
      Restart = "always";
      User = "navidrome";
    };
  };

  users.users.navidrome = {
    uid = 90;
    inherit home;
    createHome = true;
  };

  users.groups.navidrome.gid = 90;
}
