{ lib
, stdenvNoCC
, jekyll
, doTar ? false
, gnutar
}:
with lib;

stdenvNoCC.mkDerivation {
  name = "die-koma.org${optionalString doTar ".tar.xz"}";
  src = ../.;

  nativeBuildInputs = [ jekyll ];

  buildPhase = ''
    rm -rf env-vars flake.lock flake.nix Makefile nix README.md
    jekyll build --destination=build
  '';

  installPhase =
    if doTar
    then "tar -cvf $out --xz build"
    else "cp -r build $out";
}
