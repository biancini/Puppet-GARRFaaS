class discojuice::prerequisites(
  $dsfqdn = 'exampleservername.com',
) {

  # Install java (this operation also performs apt-get updated needed by further packages)
  include shib2common::java::package
  # include shib2common::java::download
  $java_home = $shib2common::java::params::java_home
  
  file {
    "/etc/apache2/sites-available/dsc.conf":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => join(['ProxyRequests Off',
                       '<Proxy *>',
                       '  Order deny,allow',
                       '  Allow from all',
                       '</Proxy>',
                       '',
                       'ProxyPass /dsc ajp://localhost:8009/dsc',
                       'ProxyPassReverse /dsc ajp://localhost:8009/dsc'], "\n"),
      require => [Class['apache::mod::ssl'], Apache::Mod['proxy_ajp']];

    "/etc/apache2/sites-enabled/dsc.conf":
      ensure  => link,
      target  => "/etc/apache2/sites-available/dsc.conf",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => [Class['apache'], File["/etc/apache2/sites-available/dsc.conf"]];
  }

}
