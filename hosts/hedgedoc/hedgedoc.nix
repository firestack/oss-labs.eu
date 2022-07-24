{ modulesPath, pkgs, lib, config, hostname, ... }:
let
  db_name = "hedgedoc";
  db_user = "hedgedoc";
  hedgedoc-domain = hostname;
in
{
  services.hedgedoc = {
    enable = true;
    # environmentFile = "/root/environment";
    settings = {
      host = "0.0.0.0";
      port = 3000;
      sessionSecret = "foobar";
      domain = hedgedoc-domain;
      urlAddPort = true;
      protocolUseSSL = false;
      hsts.enable = false;
      allowOrigin = [
        config.services.hedgedoc.settings.domain
        "hedgedoc"
      ];
      allowAnonymous = true;
      allowEmailRegister = false;
      allowAnonymousEdits = true;
      allowFreeURL = true;
      # imageUploadType = "minio";
      db = {
        dialect = "postgres";
        username = db_user;
        database = db_name;
        host = "/run/postgresql";
      };
      # s3bucket = "hedgedoc";
      email = false;
      gitlab = {
        baseURL = "https://code.europa.eu/";
        clientID = "Foo";
        clientSecret = "Bar";
      };
    };
  };
}

