{ pkgs, ... }:

{
  users.users.acme.uid = 999;

  security.acme = {
    acceptTerms = true;
    email = "lucas@ransan.tk";
  };

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
}
