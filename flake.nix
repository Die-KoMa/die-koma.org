{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = flakes@{ nixpkgs, ... }:
    let
      overlays = [ flakes.self.overlays.default ];
      withPkgsFor = systems: fn:
        with nixpkgs.lib;
        genAttrs systems
        (system: fn (import nixpkgs { inherit system overlays; }));
      withPkgs = withPkgsFor nixpkgs.lib.platforms.unix;
    in {
      overlays.default = final: prev:
        let
          runNpm = args: {
            type = "app";
            program = let
              build = final.writeShellScript "build" ''
                export PATH=${final.bash}/bin:${final.nodePackages.nodejs}/bin:${final.nodePackages.npm}/bin
                npm ${args}
              '';
            in "${build}";
          };
        in {
          koma-homepage = final.callPackage ./default.nix { };
          koma-homepage-tar = final.koma-homepage.override { doTar = true; };
          koma-homepage-install = runNpm ''install "$@"'';
          koma-homepage-build = runNpm "run build";
          koma-homepage-dev = runNpm ''run dev "$@"'';
        };
      apps = withPkgs (pkgs: {
        build = pkgs.koma-homepage-build;
        install = pkgs.koma-homepage-install;
        dev = pkgs.koma-homepage-dev;
        default = pkgs.koma-homepage-dev;
        check-links = {
          type = "app";
          program = let
            checkLinks = pkgs.writeShellScript "check-links" ''
              LANG="C.UTF-8" ${pkgs.html-proofer}/bin/htmlproofer --allow-hash-href --assume-extension --empty-alt-ignore --ignore-status-codes 401 ${pkgs.koma-homepage}
            '';
          in "${checkLinks}";
        };
      });
      packages = withPkgs (pkgs: {
        KoMaHomepage = pkgs.koma-homepage;
        KoMaHomepageTar = pkgs.koma-homepage-tar;

        default = pkgs.koma-homepage;
      });
      devShells = withPkgs (pkgs: {
        default = pkgs.mkShell {
          name = "koma-homepage-shell";
          buildInputs =
            [ pkgs.nodePackages.nodejs pkgs.nodePackages.npm pkgs.tailwindcss ];
        };
      });
    };
}
