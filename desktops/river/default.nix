{ pkgs, ... }:

let
  launcher = pkgs.writeShellScript "launch-river" ''
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
}
