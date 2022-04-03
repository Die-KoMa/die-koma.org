{

  inputs = {

    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    wat = {
      url = github:thelegy/wat;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { wat, ... }: wat.lib.eachDefaultSystem (system: pkgs: rec {
    systemOverlays = [ (import ./nix/overlay.nix) ];

    packages.KoMaHomepage = pkgs.KoMaHomepage;
    packages.KoMaHomepageDocker = pkgs.KoMaHomepageDocker;

    defaultPackage = packages.KoMaHomepage;

  });

}
