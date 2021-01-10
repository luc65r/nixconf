{ pkgs, ... }:

let
  home = "/home/navidrome";
  configFile = (pkgs.formats.toml {}).generate "navidrome.toml" {
    MusicFolder = "${home}/music";
  };

in {
  systemd.services.navidrome = {
    description = "Navidrome";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      mkdir ${home}/data
    '';

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
    inherit home;
    createHome = true;
  };
}
