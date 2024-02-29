{
  callPackage,
  doTar ? false,
  lib,
  node2nix,
  nodejs,
  runCommand,
  stdenv,
  vips,
  pkg-config,
}:
with lib; let
  srcN2N =
    runCommand "koma-homepage-node2nix" {
      buildInputs = [node2nix];
    } ''
      mkdir $out

      ln -s ${./package.json} $out/package.json
      ln -s ${./package-lock.json} $out/package-lock.json

      cd $out
      node2nix --lock package-lock.json --development
    '';

  resultN2N = callPackage (import srcN2N) {};

  nodeDependencies = resultN2N.nodeDependencies.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [pkg-config vips.dev];
  });
in
  stdenv.mkDerivation {
    name = "die-koma.org${optionalString doTar ".tar.xz"}";
    src = ./.;
    buildInputs = [nodejs];
    buildPhase = ''
      mkdir node_modules
      ln -s ${nodeDependencies}/lib/node_modules/* ./node_modules
      export PATH="${nodeDependencies}/bin:$PATH"

      ln -sf ${./next-koma.json} next-koma.json

      mkdir config-home
      XDG_CONFIG_HOME=config-home npm run build
    '';
    installPhase =
      if doTar
      then "tar -cvf $out --xz dist"
      else "cp -r dist $out";
  }
