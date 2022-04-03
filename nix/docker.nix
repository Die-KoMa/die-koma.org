{ dockerTools, writeScript, writeText, lighttpd, KoMaHomepage }:
with dockerTools;

let

  lighttpd_conf = writeText "lightppd.conf" ''
    var.basedir  = "/var/www/localhost"
    var.statedir = "/var/lib/lighttpd"

    include "${lighttpd}/share/lighttpd/doc/config/conf.d/mime.conf"
    server.document-root = "${KoMaHomepage}"
    server.pid-file      = "/run/lighttpd.pid"

    server.indexfiles    = ("index.php", "index.html", "index.htm", "default.htm")
    server.follow-symlink = "enable"
    static-file.exclude-extensions = (".php", ".pl", ".cgi", ".fcgi")
  '';

in
buildImage {

  name = "die-koma-homepage";

  runAsRoot = ''
    mkdir -p /var/tmp /var/www/localhost /var/lib/lighttpd /run
  '';

  config.Cmd = [ "${lighttpd}/bin/lighttpd" "-D" "-f" "${lighttpd_conf}" ];
  config.ExposedPorts = {
    "80" = { };
  };

}
