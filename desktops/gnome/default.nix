{ lib, config, ... }:

{
  services.xserver = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  services.gnome = {
    core-developer-tools.enable = true;
  };

  hardware.pulseaudio.enable = lib.mkForce (!config.services.pipewire.pulse.enable);
}
