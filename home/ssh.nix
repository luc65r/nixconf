{ ... }:

{
  programs.ssh = {
    enable = true;
    # Fix pinentry spawning on the wrong terminal
    # https://bugzilla.mindrot.org/show_bug.cgi?id=2824#c9
    extraConfig = ''
      Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
    '';
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

    pinentryFlavor = "tty";
    extraConfig = ''
      allow-loopback-pinentry
    '';

    defaultCacheTtl = 1800;
    maxCacheTtl = 8 * defaultCacheTtl;
    defaultCacheTtlSsh = 1800;
    maxCacheTtlSsh = 8 * defaultCacheTtlSsh;
  };
}
