class discojuice::ds(
  $dsfqdn              = 'exampleservername.com',
  $technicalEmail      = 'user@domain',
  $technicalGivenName  = 'administrator',
  $technicalSurName    = 'name',
  $federation_name     = 'Test Federation',
) {
  
  $disco_feed_url = $discojuice::prerequisites::my_discofeed_url
  
  file {
    '/var/www/disco':
      ensure  => directory,
      require => Class['apache'];
      
    ['css', 'js', 'flags', 'images']:
      path    => "/var/www/disco/${name}",
      ensure  => directory,
      require => File['/var/www/disco'];
      
    ['discojuice.css']:
      path    => "/var/www/disco/css/${name}",
      ensure  => present,
      source  => "puppet:///modules/discojuice/css/${name}",
      require => File['/var/www/disco/css'],
      notify  => Service['httpd'];
      
    ['discojuice-stable.min.js', 'idpdiscovery.js', 'jquery.min.js', 'jquery.min.map']:
      path    => "/var/www/disco/js/${name}",
      ensure  => present,
      source  => "puppet:///modules/discojuice/js/${name}",
      require => File['/var/www/disco/js'],
      notify  => Service['httpd'];
            
    ['index.php']:
      path    => "/var/www/disco/${name}",
	    ensure  => present,
	    content => template("discojuice/${name}.erb"),
	    require => File['/var/www/disco'],
	    notify  => Service['httpd'];
	    
	  ['it.png']:
	    path    => "/var/www/disco/flags/${name}",
      ensure  => present,
      source  => "puppet:///modules/discojuice/flags/${name}",
      require => File['/var/www/disco/flags'],
      notify  => Service['httpd'];
    
    ['error.png', 'info.png', 'spinning.gif']:
      path    => "/var/www/disco/images/${name}",
      ensure  => present,
      source  => "puppet:///modules/discojuice/images/${name}",
      require => File['/var/www/disco/images'],
      notify  => Service['httpd'];
  }
  
}
