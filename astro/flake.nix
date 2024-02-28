{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = flakes @ {nixpkgs, ...}: let
    overlays = [
      flakes.self.overlays.default
    ];
    withPkgsFor = systems: fn: with nixpkgs.lib; genAttrs systems (system: fn (import nixpkgs {inherit system overlays;}));
    withPkgs = withPkgsFor nixpkgs.lib.platforms.unix;
  in {
    overlays.default = final: prev: {
      koma-homepage = final.callPackage ./default.nix {};
      koma-homepage-tar = final.koma-homepage.override {doTar = true;};
      koma-homepage-build = {
        type = "app";
        program = let
          build = final.writeShellScript "build" ''
            export PATH=${final.bash}/bin:${final.nodePackages.nodejs}/bin:${final.nodePackages.npm}/bin
            npm run build
          '';
        in "${build}";
      };
      koma-homepage-dev = {
        type = "app";
        program = let
          build = final.writeShellScript "build" ''
            export PATH=${final.bash}/bin:${final.nodePackages.nodejs}/bin:${final.nodePackages.npm}/bin
            npm run dev "$@"
          '';
        in "${build}";
      };
    };
    apps = withPkgs (pkgs: {
      build = pkgs.koma-homepage-build;
      dev = pkgs.koma-homepage-dev;
      default = pkgs.koma-homepage-dev;
    });
    packages = withPkgs (pkgs: {
      KoMaHomepage = pkgs.koma-homepage;
      KoMaHomepageTar = pkgs.koma-homepage-tar;

      default = pkgs.koma-homepage;
    });
    devShells = withPkgs (pkgs: {
      default = pkgs.mkShell {
        name = "koma-homepage-shell";
        buildInputs = [
          pkgs.nodePackages.nodejs
          pkgs.nodePackages.npm
          pkgs.tailwindcss
        ];
      };
    });
  };
}
