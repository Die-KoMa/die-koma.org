{
  lib,
  ...
}:
{

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

      packages.KoMaHomepage = pkgs.buildNpmPackage {
        pname = "die-koma.org";
        version = "0.0.1";
        inherit src;

        npmDeps = pkgs.importNpmLock {
          npmRoot = src;
        };
        npmConfigHook = pkgs.importNpmLock.npmConfigHook;

        installPhase = ''
          runHook preInstall

          cp -R dist $out/

          runHook postInstall
        '';
      };

      packages.KoMaHomepageTar = pkgs.runCommand "die-koma.org.tar.xz" { } ''
        cp -r ${packages.KoMaHomepage} dist
        tar -cvf $out --xz dist
      '';

      packages.default = packages.KoMaHomepage;

      devShells.default = pkgs.mkShell {
        packages = builtins.attrValues {
          inherit (pkgs) nodejs tailwindcss;
          inherit (pkgs.nodePackages) npm;
        };
      };
    in
    {
      inherit
        devShells
        packages
        ;
    };
}
