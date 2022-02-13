{ pkgs, ... }:

let
  launcher = pkgs.writeShellScript "launch-river" ''
    . "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    export XKB_DEFAULT_LAYOUT=fr
    export XKB_DEFAULT_VARIANT=bepo
    export XKB_DEFAULT_OPTIONS=ctrl:swapcaps
    systemd-cat --identifier=river river
  '';
in {
  services.greetd = {
    enable = true;
    package = pkgs.greetd.greetd;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${launcher}";
      };
    };
  };

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings.screencast = {
        output_name = "eDP-1";
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
  };
}
