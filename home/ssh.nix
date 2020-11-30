{ ... }:

{
  programs.ssh = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = rec {
    enable = true;
    enableSshSupport = true;

    sshKeys = [
      "CF3A5BE1AE37A59C2B06FFE27EF6C6758269833E"
    ];

    defaultCacheTtl = 1800;
    maxCacheTtl = 8 * defaultCacheTtl;
    defaultCacheTtlSsh = 1800;
    maxCacheTtlSsh = 8 * defaultCacheTtlSsh;
  };
}
