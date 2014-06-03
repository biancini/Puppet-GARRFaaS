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
      
    '/var/www/disco/index.php':
      ensure  => present,
      content => template('discojuice/index.php.erb'),
      require => File['/var/www/disco'],
      notify  => Service['httpd'];
    
    '/var/www/disco/css/':
      ensure       => directory,
      source       => ['puppet:///modules/discojuice/css/discojuice.css'],
      sourceselect => all,
      require      => File['/var/www/disco'];  
    
    '/var/www/disco/js/':
      ensure       => directory,
      source       => [
        'puppet:///modules/discojuice/js/discojuice-stable.min.js',
        'puppet:///modules/discojuice/js/idpdiscovery.js',
        'puppet:///modules/discojuice/js/jquery.min.js',
        'puppet:///modules/discojuice/js/jquery.min.map',
      ],
      sourceselect => all,
      require      => File['/var/www/disco'];
      
    '/var/www/disco/flags/':
      ensure       => directory,
      source       => ['puppet:///modules/discojuice/flags/it.png'],
      sourceselect => all,
      require      => File['/var/www/disco'];
      
    '/var/www/disco/images/':
      ensure       => directory,
      source       => [
        'puppet:///modules/discojuice/images/error.png',
        'puppet:///modules/discojuice/images/info.png',
        'puppet:///modules/discojuice/images/spinning.gif',
      ],
      sourceselect => all,
      require      => File['/var/www/disco'];
  }
  
}
