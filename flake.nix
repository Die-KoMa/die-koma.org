{

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

  outputs = { nixpkgs, ... }: {

    packages.x86_64-linux = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in rec {

      KoMaHomepage = pkgs.runCommand "KoMaHomepage" {} ''
        cp -r --reflink=auto ${./homepage} $out
      '';

      default = KoMaHomepage;

    };

  };

}
