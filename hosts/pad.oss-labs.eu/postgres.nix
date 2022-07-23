{ modulesPath, pkgs, lib, config, ... }:
let
  db_name = "hedgedoc";
  db_user = "hedgedoc";
in
{
  services.postgresql =
    {
      enable = true;
      package = pkgs.postgresql_13;
      ensureDatabases = [ db_name ];
      ensureUsers = [
        {
          name = db_user;
          ensurePermissions = { "DATABASE ${db_name}" = "ALL PRIVILEGES"; };
        }
      ];
    };
}
