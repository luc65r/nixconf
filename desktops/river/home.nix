{ pkgs, ... }:

let
  nordTheme = import ../../colorthemes/nord.nix;
  nord = n: builtins.substring 1 7 (builtins.elemAt nordTheme.palette n);
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (old: {
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/Alexays/Waybar/commit/024fd42e272f79cb08e594eb3af86c93b1446c91.patch";
          sha256 = "NExAWhuizKiyYgAPNIUPucGz5GDi8umevAOY5HtLQJk=";
        })
      ];
    });
    systemd.enable = true;

    settings = [{
      layer = "top";
      position = "top";
      height = 16;
      output = [
        "eDP-1"
        "HDMI-A-1"
      ];
      modules-left = [
        "river/tags"
      ];
      modules-center = [];
      modules-right = [
        "battery"
        "tray"
        "clock"
      ];
    }];
  };

  services.fnott = {
    enable = true;
    settings = rec {
      main = {
      };
      normal = {
        background = nord 0;
        border-color = nord 4;
        border-size = 1;
        title-font = "Iosevka:weight=bold:size=13";
        title-color = nord 4;
        summary-font = "Iosevka:size=13";
        summary-color = nord 4;
        body-font = "Iosevka:size=13";
        body-color = nord 4;
      };
      low = normal;
      critical = normal // {
        border-color = nord 11;
      };
    };
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "river-session.target";
    profiles = {
      docked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
          }
        ];
      };
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      };
    };
  };

  systemd.user.targets.river-session.Unit = {
    Description = "river compositor session";
    BindsTo = [ "graphical-session.target" ];
    Wants = [ "graphical-session-pre.target" ];
    After = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.wbg = {
    Unit = {
      Description = "set wallpaper";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wbg}/bin/wbg /home/lucas/Wallpapers/nord-vice-city.png";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  home.packages = with pkgs; [
    river
    fuzzel
    alacritty
    kanshi
    wbg
  ];
}
