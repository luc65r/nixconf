{ lib
, rustPlatform
, fetchFromGitHub
, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "botCYeste";
  version = "0.2.0";
  
  src = fetchFromGitHub {
    owner = "luc65r";
    repo = pname;
    rev = "a86831dd3ff924bc5c49d347646a207a12f34833";
    sha256 = lib.fakeSha256;
  };
  
  cargoSha256 = lib.fakeSha256;
  
  buildInputs = [
    sqlite
  ];
}
