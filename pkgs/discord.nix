{ fetchurl
, makeDesktopItem
, lib
, stdenv
, makeWrapper
, chromium
}:

stdenv.mkDerivation rec {
  pname = "discord-chromium";
  version = "0.0.1";

  src = fetchurl {
    url = "https://discord.com/assets/f9bb9c4af2b9c32a2c5ee0014661546d.png";
    sha256 = "BCS6rXFDD3Zmrpmm/3zhVTvPBev+Ld2dgP/7wewWQaI=";
  };

  buildInputs = [
    chromium
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,share/pixmaps}
    ln -s ${src} $out/share/pixmaps/discord.png
    ln -s ${desktopItem}/share/applications $out/share

    makeWrapper ${chromium}/bin/chromium $out/bin/discord \
      --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
      --add-flags "--ozone-platform=wayland" \
      --add-flags "--user-data-dir=\$XDG_CONFIG_HOME/discord-chromium" \
      --add-flags "--app=https://discord.com/app"
  '';

  desktopItem = makeDesktopItem {
    name = "discord";
    exec = "discord";
    icon = "discord";
    desktopName = "discord";
    genericName = meta.description;
    categories = [ "Network" "InstantMessaging" ];
    mimeTypes = [ "x-scheme-handler/discord" ];
  };

  meta = with lib; {
    description = "All-in-one cross-platform voice and text chat for gamers";
    homepage = "https://discord.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ luc65r ];
    platforms = chromium.meta.platforms;
  };
}
