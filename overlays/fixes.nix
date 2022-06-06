self: super: rec {
  python3 = super.python3.override {
    packageOverrides = self: super: {
      remarshal = super.remarshal.overrideAttrs (old: {
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace "poetry.masonry.api" "poetry.core.masonry.api" \
            --replace 'PyYAML = "^5.3"' 'PyYAML = "*"' \
            --replace 'tomlkit = "^0.7"' 'tomlkit = "*"'
        '';
      });
    };
  };

  python3Packages = python3.pkgs;

  libowfat = super.libowfat.overrideAttrs (old: {
    postPatch = ''
      # do not define "__pure__", this the gcc builtin
      sed 's#__pure__;#__attribute__((__pure__));#' -i fmt.h scan.h byte.h stralloc.h str.h critbit.h
      sed 's#__pure__$#__attrib__pure__#' -i  fmt.h scan.h byte.h stralloc.h str.h critbit.h
      # remove unneeded definition of __deprecated__
      sed '/^#define __deprecated__$/d' -i scan/scan_iso8601.c scan/scan_httpdate.c
    '';
    meta.broken = false;
  });
}
