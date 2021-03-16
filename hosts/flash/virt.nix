{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    virtmanager
    looking-glass-client
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 lucas qemu-libvirtd -"
  ];
}
