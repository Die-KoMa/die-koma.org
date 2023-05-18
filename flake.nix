{

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    wat = {
      url = "github:thelegy/wat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, wat }:
    let
      withPackages = wat.lib.withPkgsFor [ "x86_64-linux" ] nixpkgs
        [ self.overlays.default ];
    in {
      overlays.default = final: prev: {
        KoMaHomepage = final.callPackage ./nix/homepage.nix { };
        KoMaHomepageTar =
          final.callPackage ./nix/homepage.nix { doTar = true; };
      };

      packages = withPackages (pkgs: {

        KoMaHomepage = pkgs.KoMaHomepage;
        KoMaHomepageTar = pkgs.KoMaHomepageTar;

        default = pkgs.KoMaHomepage;

      });

      apps = withPackages (pkgs:
        let
          checkLinks = pkgs.writeShellScript "check-links" ''
            LANG="C.UTF-8" ${pkgs.html-proofer}/bin/htmlproofer --allow-hash-href --assume-extension --empty-alt-ignore --http-status-ignore 401 ${pkgs.KoMaHomepage}
          '';
          serve = pkgs.writeShellScript "serve" ''
            ${pkgs.jekyll}/bin/jekyll serve
          '';
        in rec {
          check-links = {
            type = "app";
            program = "${checkLinks}";
          };

          serve = {
            type = "app";
            program = "${serve}";
          };

          default = serve;
        });
    };

}
