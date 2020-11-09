{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    "${builtins.fetchTarball {
      url = "https://github.com/nix-community/impermanence/tarball/4b3000b9bec3a3ce4d5bb7d79abfdd267b5f42ea";
      sha256 = "0gwx6ggg5gw9w9xnd5k7pq8viknjb88zxn711bqmfcnvnx74hav1";
    }}/nixos.nix"
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
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    label = "nix";
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

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/var/log"
      "/var/lib/bluetooth"
    ];
  };
}
