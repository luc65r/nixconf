{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xmobar;

in {
  options = {
    services.xmobar = {
      enable = mkEnableOption "xmobar status bar";
      systemdLaunch = mkEnableOption "launch with Systemd";

      config = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          The configuration file to be used for xmobar.
        '';
      };

      compileConfigFile = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Compile the config file.
          Enable if the config is Haskell.
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
    }

    (mkIf cfg.systemdLaunch {
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
    })

    (mkIf (cfg.config != null) {
      xdg.configFile."xmobar/xmobarrc".source = cfg.config;
    })

    (mkIf (cfg.compileConfigFile && (cfg.config != null)) {
      xdg.configFile."xmobar/xmobarrc".onChange = ''
        echo "Compiling xmobar config"
        $DRY_RUN_CMD "${pkgs.ghc}/bin/ghc" --make -- "${config.xdg.configHome}/xmobar/xmobarrc"
      '';
    })
  ]);
}
