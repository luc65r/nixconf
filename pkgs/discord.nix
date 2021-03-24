{ autoPatchelfHook, fetchurl, makeDesktopItem, lib, stdenv, wrapGAppsHook
, alsaLib, at-spi2-atk, at-spi2-core, atk, cairo, cups, dbus, expat, fontconfig
, freetype, gdk-pixbuf, glib, gtk3, libcxx, libdrm, libnotify, libpulseaudio, libuuid
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb
, mesa, nspr, nss, pango, systemd, libappindicator-gtk3, libdbusmenu
, electron_12, nodePackages, gsettings-desktop-schemas
}:

let
  binaryName = "Discord";
  desktopName = "Discord";
in stdenv.mkDerivation rec {
  pname = "discord-wayland";
  version = "0.0.14";

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
    sha256 = "1rq490fdl5pinhxk8lkfcfmfq7apj79jzf3m14yql1rc9gpilrf2";
  };

  buildInputs = [
    electron_12
  ];

  nativeBuildInputs = [
    nodePackages.asar
    alsaLib
    autoPatchelfHook
    cups
    libdrm
    libuuid
    libX11
    libXScrnSaver
    libXtst
    libxcb
    mesa.drivers
    nss
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  libPath = lib.makeLibraryPath [
    libcxx systemd libpulseaudio
    stdenv.cc.cc alsaLib atk at-spi2-atk at-spi2-core cairo cups dbus expat fontconfig freetype
    gdk-pixbuf glib gtk3 libnotify libX11 libXcomposite libuuid
    libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender
    libXtst nspr nss libxcb pango systemd libXScrnSaver
    libappindicator-gtk3 libdbusmenu gsettings-desktop-schemas
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib/${binaryName},opt/${binaryName},share/pixmaps}
    cp -r * $out/opt/${binaryName}

    asar e resources/app.asar resources/app
    rm resources/app.asar
    sed -i "s|process.resourcesPath|'$out/lib/${binaryName}'|" \
      resources/app/app_bootstrap/buildInfo.js
    sed -i "s|exeDir,|'$out/share/pixmaps',|" resources/app/app_bootstrap/autoStart/linux.js

    asar p resources/app resources/app.asar --unpack-dir '**'
    rm -rf resources/app

    cp -r resources/* $out/lib/${binaryName}/

    ln -s $out/opt/${binaryName}/discord.png $out/share/pixmaps/${pname}.png

    ln -s "${desktopItem}/share/applications" $out/share/
  '';

  postFixup = ''
    makeWrapper ${electron_12}/bin/electron $out/bin/${binaryName} \
      --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
      --add-flags "--ozone-platform=wayland" \
      --add-flags "--enable-gpu" \
      --add-flags $out/lib/${binaryName}/app.asar \
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --prefix LD_LIBRARY_PATH : ${libPath}
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = binaryName;
    icon = pname;
    inherit desktopName;
    genericName = meta.description;
    categories = "Network;InstantMessaging;";
    mimeType = "x-scheme-handler/discord";
  };

  meta = with lib; {
    description = "All-in-one cross-platform voice and text chat for gamers";
    homepage = "https://discordapp.com/";
    downloadPage = "https://discordapp.com/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ ldesgoui MP2E tadeokondrak luc65r ];
    platforms = [ "x86_64-linux" ];
  };
}
