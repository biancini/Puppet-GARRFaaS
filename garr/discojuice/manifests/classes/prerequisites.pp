class discojuice::prerequisites(
  $dsfqdn        = 'exampleservername.com',
  $mailto        = 'user@domain',
  $discofeed_url = undef,
) {

  # Install java (this operation also performs apt-get updated needed by further packages)
  include shib2common::java::package
  # include shib2common::java::download
  $java_home = $shib2common::java::params::java_home
  
  file {
    "/etc/apache2/sites-available/discojuice.conf":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => join(['Alias /disco "/var/www/disco"',
                       '<Directory /var/www/disco>',
                       '        Options Indexes FollowSymLinks MultiViews',
                       '        AllowOverride All',
                       '        Order allow,deny',
                       '        allow from all',
                       '</Directory>'], "\n"),
      require => [Class['apache::mod::ssl'], Apache::Mod['proxy_ajp']],
      notify  => Service['httpd'];

    "/etc/apache2/sites-enabled/discojuice.conf":
      ensure  => link,
      target  => "/etc/apache2/sites-available/discojuice.conf",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => [Class['apache'], File["/etc/apache2/sites-available/discojuice.conf"]],
      notify  => Service['httpd'];
  }
  
  if ($discofeed_url) {
    $my_discofeed_url = $discofeed_url
  }
  else {
    $my_discofeed_url = "https://${dsfqdn}/Shibboleth.sso/DiscoFeed"
    
	  shib2common::instance { "${hostname}-common":
	    install_apache          => true,
	    install_tomcat          => false,
	    configure_admin         => false,
	    hostfqdn                => $dsfqdn,
	    mailto                  => $mailto,
	    nagiosserver            => undef,
	  }
	
	  shib2sp::instance { "${hostname}-sp":
	    metadata_information => { },
	    session_initiator    => { },
	    apache_doc_root      => '/opt',
	  }
  }
}
