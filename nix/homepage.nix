{ lib
, stdenvNoCC
, jekyll
, doTar ? false
}:
with lib;

stdenvNoCC.mkDerivation {
  name = "die-koma.org${optionalString doTar ".tar.xz"}";
  src = ../.;

  nativeBuildInputs = [ jekyll ];

  dontConfigure = true;

  buildPhase = ''
    rm -rf env-vars flake.lock flake.nix Makefile nix README.md
    jekyll build --destination=build --verbose
  '';

  installPhase =
    if doTar
    then "tar -cvf $out --xz build"
    else "cp -r build $out";
}
