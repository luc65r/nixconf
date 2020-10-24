{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xmobar;

in {
  options = {
    services.xmobar = {
      enable = mkEnableOption "xmobar status bar";

      config = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          The configuration file to be used for xmobar.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.xmobar;
        defaultText = "pkgs.xmobar";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [ cfg.package ];

      systemd.user.services.xmobar = {
        Unit = {
          Description = "xmobar status bar";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${cfg.package}/bin/xmobar";
          Restart = "on-failure";
        };

        Install = { WantedBy = [ "graphical-session.target" ]; };
      };
    }

    (mkIf (cfg.config != null) {
      xdg.configFile."xmobar/xmobarrc".source = cfg.config;
    })
  ]);
}
