{ secrets, ... }:

{
  accounts.email = {
    accounts = {
      tedomum = {
        primary = true;
        address = "lucas@ransan.tk";
        realName = "Lucas Ransan";
        inherit (secrets.mail.tedomum) userName;
        passwordCommand = "echo '${secrets.mail.tedomum.password}'";
        imap = {
          host = "mail.tedomum.net";
          port = 993;
        };
        smtp = {
          host = "mail.tedomum.net";
          port = 465;
        };
        mbsync = {
          enable = true;
          create = "both";
        };
        mu = {
          enable = true;
        };
        msmtp = {
          enable = true;
        };
      };

      eisti = {
        address = "lucas.ransan@eisti.eu";
        realName = "Lucas Ransan";
        inherit (secrets.mail.eisti) userName;
        passwordCommand = "echo '${secrets.mail.eisti.password}'";
        flavor = "gmail.com";
        mbsync = {
          enable = true;
          create = "both";
        };
        mu = {
          enable = true;
        };
        msmtp = {
          enable = true;
        };
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
