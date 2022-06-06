{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    virtmanager
    looking-glass-client
    scream
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf = true;
      runAsRoot = false;
    };
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  environment.persistence."/persist".directories = [
    "/var/lib/libvirt"
  ];

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 lucas qemu-libvirtd -"
  ];

  networking.firewall.allowedUDPPorts = [
    4010
  ];

  systemd.user.services.scream = {
    enable = false;
    description = "Scream";
    serviceConfig = {
      ExecStart = "${
        pkgs.scream-receivers.override {
          pulseSupport = true;
        }
      }/bin/scream-pulse -i virbr0";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
    requires = [ "pulseaudio.service" ];
  };
}
