{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = {nixpkgs, ...}: let
    overlays = [
    ];
    withPkgsFor = systems: fn: with nixpkgs.lib; genAttrs systems (system: fn (import nixpkgs {inherit system overlays;}));
    withPkgs = withPkgsFor nixpkgs.lib.platforms.unix;
  in {
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
