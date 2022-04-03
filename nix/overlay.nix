final: prev:
with final.lib;
with final;

{

  KoMaHomepage = callPackage ./homepage.nix {};
  KoMaHomepageDocker = callPackage ./docker.nix {};

}
