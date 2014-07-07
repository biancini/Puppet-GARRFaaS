define jagger::federation (
  $rootpw                 = 'puppetsecret',
  $federation_id          = 'FEDERATION',
  $federation_name        = 'FEDERATION DESCRIPTION',
  $federation_description = '',
  $federation_tou         = '',
  $domain_name            = 'example.com',
) {
  
  execute_mysql { "create federation ${federation_name}":
    user              => 'root',
    password          => $rootpw,
    dbname            => 'rr3',
    query_check_empty => "SELECT * FROM federation WHERE name = '${federation_name}'",
    sql => [join(['INSERT INTO federation (name, urn, publisher, description, is_active, is_protected, is_public, is_lexport, is_local, attrreq_inmeta, tou, owner,sysname)',
                  "  VALUES ('${federation_name}', 'urn:mace:${domain_name}:${federation_id}', NULL, '${federation_description}', '1', 0, 1, 0, 1, 0, '${federation_tou}', 'admin', '${federation_id}')\n",
                  'INSERT INTO acl_resource (resource, description, type, default_value, parent_id)',
                  '  VALUES (CONCAT(\'f_\', LAST_INSERT_ID()), NULL, \'federation\', \'read\', \'6\')'], ' ')];
  }

}
