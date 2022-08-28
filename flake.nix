{

  inputs = {

    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    wat = {
      url = github:thelegy/wat;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, wat }: {

    overlays.default = final: prev: {
      KoMaHomepage = final.callPackage ./nix/homepage.nix {};
      KoMaHomepageDocker = final.callPackage ./nix/docker.nix {};
    };

    packages = wat.lib.withPkgsForLinux nixpkgs [ self.overlays.default ] (pkgs: {

      KoMaHomepage = pkgs.KoMaHomepage;
      KoMaHomepageDocker = pkgs.KoMaHomepageDocker;

      default = pkgs.KoMaHomepage;

    });

  };

}
