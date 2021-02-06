{ stdenv
, lib
, fetchFromGitHub
, cmake
, pciutils
}:

stdenv.mkDerivation rec {
  pname = "ryzenadj";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "FlyGoat";
    repo = "RyzenAdj";
    rev = "v${version}";
    sha256 = "fc5e140d4ee95c2e88f6a0882cf85cc84b4fd4587c69d686e3f3c2d9c7c1c435";
  };

  buildInputs = [
    pciutils
  ];

  nativeBuildInputs = [
    cmake
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ryzenadj $out/bin
  '';

  meta = with lib; {
    description = "Adjust power management settings for Mobile Raven Ridge Ryzen Processors";
    homepage = "https://github.com/FlyGoat/RyzenAdj";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ luc65r ];
  };
}
