{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cyrel-functions";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Cyrel-org";
    repo = pname;
    rev = "f218879590ff808cf8181db46364ee28ec1af002";
    sha256 = lib.fakeSha256;
  };

  vendorSha256 = lib.fakeSha256;
};
