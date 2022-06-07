{ pkgs, ... }:

let
  dataDir = "/srv/minecraft";

in {
  systemd.services.minecraft = {
    description = "Minecraft Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${dataDir}/start.sh";
      User = "minecraft";
      WorkingDirectory = dataDir;
    };

    path = with pkgs; [ jdk17_headless ];
  };

  users.users.minecraft = {
    isSystemUser = true;
    group = "minecraft";
  };
  users.groups.minecraft = {};

  networking.firewall = {
    allowedTCPPorts = [
      25565
    ];
    allowedUDPPorts = [
      25565
    ];
  };
}
