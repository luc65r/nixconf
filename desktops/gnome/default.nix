{ lib, pkgs, config, ... }:

{
  services.xserver = {
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.desktop.peripherals.mouse]
        middle-click-emulation=true
        accel-profile='flat'
      '';
    };
    displayManager.gdm.enable = true;
  };

  services.gnome = {
    core-developer-tools.enable = true;
  };

  hardware.pulseaudio.enable = lib.mkForce (!config.services.pipewire.pulse.enable);

  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
  ];
}
