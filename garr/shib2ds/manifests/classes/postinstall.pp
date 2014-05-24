class shib2ds::postinstall(
  $federation_name = 'Test Federation',
  $test_federation = true,
) {
  $curtomcat = $::tomcat::curtomcat
  $federation_identifier = regsubst($federation_name, ' ','')
  
  file { '/opt/shibboleth-ds/conf/wayfconfig.xml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("shib2ds/wayfconfig.xml.erb"),
    require => Shibbolethds_install['execute_install'],
  }
  
  if ($test_federation) {
    $additional_metadata = 'https://www.idem.garr.it/docs/conf/signed-test-metadata.xml'
  } else {
    $additional_metadata = 'https://www.idem.garr.it/docs/conf/signed-metadata.xml'
  }
  
  download_file { "/opt/shibboleth-ds/metadata/${federation_identifier}.xml":
    url     => $additional_metadata,
    require => Shibbolethds_install['execute_install'],
  }
  
}
