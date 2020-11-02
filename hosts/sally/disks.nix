{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      luks.devices."persist".device = "/dev/disk/by-uuid/9ea72a37-3975-4a72-aba0-f3b8c33f692d";
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
  };

  fileSystems."/persist" = {
    device = "/dev/mapper/persist";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    label = "/nix";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "boot";
    fsType = "vfat";
  };

  swapDevices = [
    {
      label = "/swap";
    }
  ];

  services.fstrim.enable = true;
}
