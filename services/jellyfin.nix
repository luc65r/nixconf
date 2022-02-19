{ lib, ... }:

{
  services.jellyfin = {
    enable = true;
  };

  systemd.services.jellyfin.serviceConfig = {
    DeviceAllow = lib.mkForce [ "char-drm rw" "char-nvidia-frontend rw" "char-nvidia-uvm rw" ];
    PrivateDevices = lib.mkForce false;
    RestrictAddressFamilies = lib.mkForce [ "AF_UNIX" "AF_NETLINK" "AF_INET" "AF_INET6" ];
  };

  services.nginx.virtualHosts."jellyfin.ransan.tk" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:8096";
  };

  networking.firewall.allowedUDPPorts = [
    1900 7359
  ];
}
