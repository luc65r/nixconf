{ pkgs, ... }:

{
  systemd.services.botCYeste = {
    description = "Discord bot";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${pkgs.botCYeste}/bin/bot_cyeste";
      User = "cyeste";
      WorkingDirectory = "/srv/botCYeste";
    };
  };

  users.users.cyeste = {
    isSystemUser = true;
  };
}
