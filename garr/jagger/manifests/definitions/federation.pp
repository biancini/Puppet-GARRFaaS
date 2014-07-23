define jagger::federation (
  $rootpw                 = 'puppetsecret',
  $federation_id          = 'FED',
  $federation_name        = 'FEDERATION',
  $federation_description = 'FEDERATION DESCRIPTION',
  $federation_tou         = '',
  $domain_name            = 'example.com',
) {
  
  $t = generate('/bin/date', '+%Y-%m-%d %H:%M:%S')
  $timestamp = chomp("${t}")
  
  $fed_validator_name = "${federation_id} validator"
  $fed_validator_description = "Metadata validator for the federation: ${federation_name}"
  
  execute_mysql {
  	"create federation ${federation_name}":
	    user              => 'root',
	    password          => $rootpw,
	    dbname            => 'rr3',
	    query_check_empty => "SELECT * FROM federation WHERE name = '${federation_name}'",
	    sql => [join(['INSERT INTO federation (name, urn, publisher, description, is_active, is_protected, is_public, is_lexport, is_local, attrreq_inmeta, tou, owner, sysname)',
	                  "  VALUES ('${federation_name}', 'urn:mace:${domain_name}:${federation_id}', NULL, '${federation_description}', '1', 0, 1, 0, 1, 0, '${federation_tou}', 'admin', '${federation_id}')\n",
	                  'INSERT INTO acl_resource (resource, description, type, default_value, parent_id)',
	                  '  VALUES (CONCAT(\'f_\', LAST_INSERT_ID()), NULL, \'federation\', \'read\', \'6\')'], ' ')];
	                  
  	"create federation validator ${federation_name}":
	    user              => 'root',
	    password          => $rootpw,
	    dbname            => 'rr3',
	    query_check_empty => "SELECT * FROM fedvalidator WHERE name = '${fed_validator_name}'",
	    sql => [join(['INSERT INTO fedvalidator (name, is_enabled, url, method, entityparam, optargs, argseparator, documenttype, description, returncodeelement, returncodevalue, messagecodeelement, created_at, updated_at, federation_id)',
	                  " VALUES ('${fed_validator_name}', 1, 'https://${fqdn}/validation.php?', 'GET', 'meta', 'a:0:{}', '&', 'xml', '${fed_validator_description}', 'a:1:{i:0;s:10:\\\"returncode\\\";}', 'a:4:{s:7:\\\"success\\\";a:1:{i:0;s:1:\\\"0\\\";}s:5:\\\"error\\\";a:1:{i:0;s:1:\\\"2\\\";}s:7:\\\"warning\\\";a:1:{i:0;s:1:\\\"1\\\";}s:8:\\\"critical\\\";a:1:{i:0;s:1:\\\"3\\\";}}', 'a:3:{i:0;s:5:\\\"error\\\";i:1;s:7:\\\"warning\\\";i:2;s:4:\\\"info\\\";}',",
	                  " '${timestamp}', '${timestamp}', (SELECT id FROM federation WHERE sysname = '${federation_id}'))"], ' ')];
  }

}
