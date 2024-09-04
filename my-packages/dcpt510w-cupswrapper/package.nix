{
  lib,
  stdenv,
  fetchurl,
  dpkg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dcpt510w-cupswrapper";
  version = "1.0.1-0";
  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103620/dcpt510wpdrv-${finalAttrs.version}.i386.deb";
    hash = "sha256-hbfVL+sO9/A62q62rafzHHJ8LjuEaHNVXLXZySXiVtw=";
  };

  nativeBuildInputs = [
    dpkg
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg-deb -x $src $out

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother DCP-T510W printer driver";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.fqidz ];
  };
})
