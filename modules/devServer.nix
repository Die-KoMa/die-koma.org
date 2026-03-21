{

  perSystem =
    {
      pkgs,
      ...
    }:
    let
      runNpm = args: {
        type = "app";
        program =
          let
            build = pkgs.writeShellScript "build" ''
              export PATH=${pkgs.bash}/bin:${pkgs.nodePackages.nodejs}/bin:${pkgs.nodePackages.npm}/bin
              npm ${args}
            '';
          in
          "${build}";
      };
    in
    {

      apps.default = runNpm ''run dev "$@"'';

    };

}
