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
      koma-homepage-build = {
        type = "app";
        program = let
          build = final.writeShellScript "build" ''
            export PATH=${final.nodePackages.nodejs}/bin
            ${final.bun}/bin/bun run build
          '';
        in "${build}";
      };
      koma-homepage-dev = {
        type = "app";
        program = let
          build = final.writeShellScript "build" ''
            export PATH=${final.nodePackages.nodejs}/bin
            ${final.bun}/bin/bun run dev "$@"
          '';
        in "${build}";
      };
    };
    apps = withPkgs (pkgs: {
      build = pkgs.koma-homepage-build;
      dev = pkgs.koma-homepage-dev;
      default = pkgs.koma-homepage-dev;
    });
    devShells = withPkgs (pkgs: {
      default = pkgs.mkShell {
        name = "koma-homepage-shell";
        buildInputs = [
          pkgs.bun
          pkgs.nodePackages.nodejs
          pkgs.nodePackages.npm
          pkgs.tailwindcss
        ];
      };
    });
  };
}
