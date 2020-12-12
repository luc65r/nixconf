{ ... }:

{
  services.vsftpd = {
    enable = true;
    localUsers = true;
    userlistDeny = true;
  };

  users = {
    groups.transmission.gid = 70;
    users.test = {
      home = "/home/test";
      password = "test";
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "transmission" ];
    };
  };
}
