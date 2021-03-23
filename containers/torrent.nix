{ ... }:

{
  services.transmission = {
    enable = true;
    home = "/home/transmission";
    openFirewall = true;
    downloadDirPermissions = "775";
    port = 9091;
    settings = {
      rpc-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-authentication-required = false;
      rpc-username = "admin";
      rpc-port = 9091;
      rpc-whitelist-enabled = true;
      rpc-whitelist = "127.0.0.1 192.168.*.* 10.*.*.*";
      rpc-host-whitelist-enabled = false;
    };
  };
}
