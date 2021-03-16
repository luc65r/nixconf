{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    virtmanager
    looking-glass-client
    scream-receivers
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
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
}
