{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    virtmanager
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
}
