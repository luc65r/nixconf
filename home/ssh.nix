{ host, ... }:

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
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';

    defaultCacheTtl = if host.type == "laptop" then 30 * 60 else 24 * 60 * 60;
    maxCacheTtl = 8 * defaultCacheTtl;
    defaultCacheTtlSsh = defaultCacheTtl;
    maxCacheTtlSsh = maxCacheTtl;
  };
}
