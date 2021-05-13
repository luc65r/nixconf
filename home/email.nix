{ secrets, lib, ... }:

{
  accounts.email = {
    accounts = let
      common = name: {
        inherit (secrets.mail.${name}) userName;
        passwordCommand = "echo '${secrets.mail.${name}.password}'";
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
        };
        mu = {
          enable = true;
        };
        msmtp = {
          enable = true;
        };
      };
    in {
      tedomum = lib.recursiveUpdate (common "tedomum") {
        primary = true;
        address = "lucas@ransan.tk";
        realName = "Lucas Ransan";
        imap = {
          host = "mail.tedomum.net";
          port = 993;
        };
        smtp = {
          host = "mail.tedomum.net";
          port = 465;
        };
      };

      eisti = lib.recursiveUpdate (common "eisti") {
        address = "lucas.ransan@cy-tech.fr";
        realName = "Lucas Ransan";
        flavor = "gmail.com";
      };
    };
  };

  programs.mbsync = {
    enable = true;
  };

  programs.mu = {
    enable = true;
  };

  programs.msmtp = {
    enable = true;
  };
}
