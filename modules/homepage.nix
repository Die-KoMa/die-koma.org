{
  inputs,
  lib,
  ...
}:
{

  flake-file.inputs.dream2nix = {
    url = "github:nix-community/dream2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  perSystem =
    {
      pkgs,
      ...
    }:
    let
      src = lib.cleanSourceWith {
        src = ../.;
        filter =
          name: _type: !(lib.hasPrefix "modules/" name || lib.hasSuffix ".nix" name || name == "flake.lock");
      };

      commonModule =
        {
          config,
          dream2nix,
          ...
        }:
        {
          version = "0.0.1";

          imports = [
            dream2nix.modules.dream2nix.nodejs-package-lock-v3
          ];

          nodejs-package-lock-v3 = {
            packageLockFile = "${config.mkDerivation.src}/package-lock.json";
          };

          paths = {
            projectRoot = src;
            projectRootFile = "flake.nix";
            package = src;
          };

          mkDerivation = {
            inherit src;
          };
        };

      homepageSrc = inputs.dream2nix.lib.evalModules {
        packageSets.nixpkgs = pkgs;
        modules = [
          commonModule
          (
            { dream2nix, ... }:
            {
              name = "KoMaHomepage";

              imports = [
                dream2nix.modules.dream2nix.nodejs-granular-v3
              ];

              mkDerivation.installPhase = ''
                runHook preInstall

                cp -R dist $out

                runHook postInstall
              '';
            }
          )
        ];
      };

      devShells.default = inputs.dream2nix.lib.evalModules {
        packageSets.nixpkgs = pkgs;
        modules = [
          commonModule
          (
            { dream2nix, ... }:
            {
              name = "koma-homepage-shell";

              imports = [
                dream2nix.modules.dream2nix.nodejs-devshell-v3
              ];

              mkDerivation.buildPhase = "mkdir $out";
              mkDerivation.nativeBuildInputs = builtins.attrValues {
                inherit (pkgs.nodePackages) nodejs npm;
                inherit (pkgs) tailwindcss;
              };

            }
          )
        ];
      };

      packages.KoMaHomepage = pkgs.runCommand "die-koma.org" { } ''
        cp -r ${homepageSrc}/dist $out
      '';
      packages.KoMaHomepageTar = pkgs.runCommand "die-koma.org.tar.xz" { } ''
        cd ${homepageSrc}
        tar -cvf $out --xz dist
      '';
      packages.default = packages.KoMaHomepage;

    in
    {
      inherit
        devShells
        packages
        ;
    };
}
