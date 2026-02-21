let
  KoMaHomepage = builtins.path {
    path = ./homepage;
    name = "KoMaHomepage";
  };
  legacyPackages.x86_64-linux = { inherit KoMaHomepage; };
in
{
  inherit legacyPackages;
}
