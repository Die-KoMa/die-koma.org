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
      KoMaHomepageTar = final.callPackage ./nix/homepage.nix { doTar = true; };
      KoMaHomepageDocker = final.callPackage ./nix/docker.nix {};
    };

    packages = wat.lib.withPkgsFor [ "x86_64-linux" ] nixpkgs [ self.overlays.default ] (pkgs: {

      KoMaHomepage = pkgs.KoMaHomepage;
      KoMaHomepageTar = pkgs.KoMaHomepageTar;
      KoMaHomepageDocker = pkgs.KoMaHomepageDocker;

      default = pkgs.KoMaHomepage;

    });

  };

}
