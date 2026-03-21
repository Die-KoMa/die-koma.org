{

  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {

      apps.check-links = {
        type = "app";
        program =
          let
            checkLinks = pkgs.writeShellScript "check-links" ''
              LANG="C.UTF-8" ${pkgs.html-proofer}/bin/htmlproofer --allow-hash-href --assume-extension --empty-alt-ignore --ignore-status-codes 401 ${self'.packages.KoMaHomepage}
            '';
          in
          "${checkLinks}";
      };

    };

}
