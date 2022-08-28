{ lib
, runCommandNoCC
, jekyll
, doTar ? false
, gnutar
}:
with lib;

let
  jekyllOutdir = if doTar then "build" else "$out";
  tarEnding = ".tar.xz";
in
runCommandNoCC "die-koma.org${optionalString doTar tarEnding}" {} ''
  cp -r --reflink=auto --no-preserve=mode ${../.}/* ./
  rm -rf Dockerfile env-vars flake.lock flake.nix Makefile nix README.md
  ${jekyll}/bin/jekyll build --destination=${jekyllOutdir}
  ${optionalString doTar "${gnutar}/bin/tar -cvf $out --xz build"}
''
