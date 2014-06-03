class discojuice::ds(
  $dsfqdn              = 'exampleservername.com',
  $technicalEmail      = 'user@domain',
  $technicalGivenName  = 'administrator',
  $technicalSurName    = 'name',
  $federation_name     = 'Test Federation',
  $test_federation     = true,
) {
  
  $disco_feed_url = $discojuice::prerequisites::discofeed_url 
  
  file {
    '/var/www/disco':
      ensure  => directory,
      require => Class['apache'];
      
    '/var/www/disco/css':
      ensure  => directory,
      require => File['/var/www/disco'];
      
    '/var/www/disco/js':
      ensure  => directory,
      require => File['/var/www/disco'];
      
    '/var/www/disco/images':
      ensure  => directory,
      require => File['/var/www/disco'];
      
    '/var/www/disco/flags':
      ensure  => directory,
      require => File['/var/www/disco'];
      
    '/var/www/disco/css/discojuice.css':
      ensure  => present,
      source  => 'puppet:///modules/discojuice/css/discojuice.css',
      require => File['/var/www/disco/css'],
      notify  => Service['httpd'];
      
    '/var/www/disco/js/discojuice-stable.min.js':
      ensure  => present,
      source  => 'puppet:///modules/discojuice/js/discojuice-stable.min.js',
      require => File['/var/www/disco/js'],
      notify  => Service['httpd'];
      
    '/var/www/disco/js/idpdiscovery.js':
      ensure  => present,
      source  => 'puppet:///modules/discojuice/js/idpdiscovery.js',
      require => File['/var/www/disco/js'],
      notify  => Service['httpd'];
      
    '/var/www/disco/js/jquery.min.js':
      ensure  => present,
      source  => 'puppet:///modules/discojuice/js/jquery.min.js',
      require => File['/var/www/disco/js'],
      notify  => Service['httpd'];
      
    '/var/www/disco/js/jquery.min.map':
      ensure  => present,
      source  => 'puppet:///modules/discojuice/js/jquery.min.map',
      require => File['/var/www/disco/js'],
      notify  => Service['httpd'];
      
    '/var/www/disco/index.php':
	    ensure  => present,
	    content => template('discojuice/index.php.erb'),
	    require => File['/var/www/disco'],
	    notify  => Service['httpd'];
	    
	  '/var/www/disco/flags/it.png':
      ensure  => present,
      source  => 'puppet:///modules/discojuice/flags/it.png',
      require => File['/var/www/disco/flags'],
      notify  => Service['httpd'];
      
    '/var/www/disco/images/error.png':
      ensure  => present,
      source  => 'puppet:///modules/discojuice/images/error.png',
      require => File['/var/www/disco/images'],
      notify  => Service['httpd'];
      
    '/var/www/disco/images/info.png':
      ensure  => present,
      source  => 'puppet:///modules/discojuice/images/info.png',
      require => File['/var/www/disco/images'],
      notify  => Service['httpd'];
      
    '/var/www/disco/images/spinning.gif':
      ensure  => present,
      source  => 'puppet:///modules/discojuice/images/spinning.gif',
      require => File['/var/www/disco/images'],
      notify  => Service['httpd'];
  }
  
}
