{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    dream2nix = {
      url = "github:nix-community/dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    flakes@{ nixpkgs, dream2nix, ... }:
    let
      overlays = [ flakes.self.overlays.default ];
      withPkgsFor =
        systems: fn:
        with nixpkgs.lib;
        genAttrs systems (system: fn (import nixpkgs { inherit system overlays; }));
      withPkgs = withPkgsFor nixpkgs.lib.platforms.unix;
    in
    {
      overlays.default =
        final: prev:
        let
          runNpm = args: {
            type = "app";
            program =
              let
                build = final.writeShellScript "build" ''
                  export PATH=${final.bash}/bin:${final.nodePackages.nodejs}/bin:${final.nodePackages.npm}/bin
                  npm ${args}
                '';
              in
              "${build}";
          };
        in
        {
          koma-homepage = final.callPackage ./default.nix { inherit dream2nix; };
          koma-homepage-tar = final.koma-homepage.override { doTar = true; };
          koma-homepage-install = runNpm ''install "$@"'';
          koma-homepage-build = runNpm "run build";
          koma-homepage-dev = runNpm ''run dev "$@"'';
          koma-homepage-audit = runNpm ''audit "$@"'';
          koma-homepage-update = runNpm ''update "$@"'';
        };
      apps = withPkgs (pkgs: {
        build = pkgs.koma-homepage-build;
        install = pkgs.koma-homepage-install;
        dev = pkgs.koma-homepage-dev;
        default = pkgs.koma-homepage-dev;
        update = pkgs.koma-homepage-update;
        audit = pkgs.koma-homepage-audit;
        check-links = {
          type = "app";
          program =
            let
              checkLinks = pkgs.writeShellScript "check-links" ''
                LANG="C.UTF-8" ${pkgs.html-proofer}/bin/htmlproofer --allow-hash-href --assume-extension --empty-alt-ignore --ignore-status-codes 401 ${pkgs.koma-homepage}
              '';
            in
            "${checkLinks}";
        };
      });
      packages = withPkgs (pkgs: {
        KoMaHomepage = pkgs.koma-homepage;
        KoMaHomepageTar = pkgs.koma-homepage-tar;

        default = pkgs.koma-homepage;
      });
      devShells = withPkgs (pkgs: {
        default = dream2nix.lib.evalModules {
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
              { config, dream2nix, ... }:
              {
                name = "koma-homepage-shell";
                version = "0.0.1";

                imports = [
                  dream2nix.modules.dream2nix.nodejs-package-lock-v3
                  dream2nix.modules.dream2nix.nodejs-devshell-v3
                ];

                mkDerivation = {
                  src = ./.;

                  nativeBuildInputs = builtins.attrValues {
                    inherit (pkgs.nodePackages) nodejs npm;
                    inherit (pkgs) tailwindcss;
                  };

                  buildPhase = "mkdir $out";
                };

                nodejs-package-lock-v3 = {
                  packageLockFile = "${config.mkDerivation.src}/package-lock.json";
                };
              }
            )
          ];
        };
      });
    };
}
