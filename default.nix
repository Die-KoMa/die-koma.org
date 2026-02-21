{
  pkgs,
  doTar ? false,
  lib,
  dream2nix,
  stdenv,
}:
with lib;
let
  homepageSrc = dream2nix.lib.evalModules {
    packageSets.nixpkgs = pkgs;

    modules = [
      {
        paths = {
          projectRoot = ./.;
          projectRootFile = "flake.nix";
          package = ./.;
        };
      }

      (
        { dream2nix, config, ... }:
        {
          name = "die-koma.org${optionalString doTar ".tar.xz"}";
          version = "0.0.1";

          imports = [
            dream2nix.modules.dream2nix.nodejs-package-lock-v3
            dream2nix.modules.dream2nix.nodejs-granular-v3
          ];

          mkDerivation = {
            src = ./.;

            installPhase = ''
              runHook preInstall

              cp -R dist $out

              runHook postInstall
            '';
          };

          nodejs-package-lock-v3 = {
            packageLockFile = "${config.mkDerivation.src}/package-lock.json";
          };

          nodejs-granular-v3 = {
            buildScript = ''
              npm run build
            '';
          };
        }
      )
    ];
  };
in
stdenv.mkDerivation {
  name = "die-koma.org${optionalString doTar ".tar.xz"}";
  src = homepageSrc;

  dontUnpack = true;
  dontPatch = true;

  buildPhase = ''
    cp -r $src/dist .
    chmod +w dist
    ln -sf ${./next-koma.json} dist/next-koma.json
  '';
  installPhase = if doTar then "tar -cvf $out --xz dist" else "cp -r dist $out";
}
