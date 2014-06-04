define discojuice::instance (
  $federation_name    = undef,
  $discofeed_url      = undef,
  $technicalEmail     = undef,
  $technicalGivenName = undef,
  $technicalSurName   = undef,
  $dsfqdn             = undef,
) {
  
  class { 'discojuice::prerequisites':
    dsfqdn        => $dsfqdn,
    discofeed_url => $discofeed_url,
  }

  # Install and configure Discojuice DS
  class { 'discojuice::ds':
    technicalEmail          => $technicalEmail,
    technicalGivenName      => $technicalGivenName,
    technicalSurName        => $technicalSurName,
    federation_name         => $federation_name,
    require                 => Class['discojuice::prerequisites'],
    notify                  => Service['httpd'],
  }
  
}
