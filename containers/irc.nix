{ ... }:

{
  services.znc = {
    enable = true;
    mutable = true;
    useLegacyConfig = false;
    openFirewall = true;

    config = {
      LoadModule = [ "webadmin" "adminlog" ];

      Listener.l = {
        Port = 5000;
        AllowWeb = true;
        IPv4 = true;
        IPv6 = true;
        SSL = false;
      };

      User.luc65r = {
        Admin = true;
        Nick = "luc65r";
        Pass.password = {
          Method = "sha256";
          Hash = "bfd758da37419b7ef18b507fbe7b00c285dec06f2b72ad5caf1cb43e18868739";
          Salt = "ezESWRZgZY-Wy8If)JzT";
        };
      };
    };
  };
}
