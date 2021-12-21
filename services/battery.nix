{ pkgs, ... }:

let
  script = pkgs.writeShellScript "check-battery-level" /* sh */ ''
    notify() {
      sudo -u lucas $dbus notify-send "$1" "$2"
    }
    dbus="$(grep -z DBUS /proc/$(pidof river)/environ)"
    capacity=$(cat /sys/class/power_supply/BAT0/capacity)
    status=$(cat /sys/class/power_supply/BAT0/status)
    if [[ $status = Discharging ]]; then
      if [[ $capacity -lt 5 ]]; then
        systemctl suspend
      elif [[ $capacity -lt 25 ]]; then
        notify "Low battery level" "$capacity%"
      fi
    elif [[ $status = Charging && $capacity -gt 80 ]]; then
      notify "Battery charged" "$capacity%"
    fi
  '';
in {
  systemd.services.battery = {
    description = "battery";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${script}";
    };

    path = with pkgs; [ sudo libnotify procps ];
  };

  systemd.timers.battery = {
    description = "battery timer";
    wantedBy = [ "timers.target" ];
    partOf = [ "battery.service" ];
    timerConfig.OnCalendar = "minutely";
  };
}
