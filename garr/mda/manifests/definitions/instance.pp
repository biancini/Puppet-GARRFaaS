define mda::instance (
  $federation_name    = undef,
  $technicalEmail     = undef,
  $technicalGivenName = undef,
  $technicalSurName   = undef,
  $mdafqdn            = undef,
) {
  
  class { 'mda::prerequisites':
    mdafqdn       => $mdafqdn,
  }

  # Install and configure Shibboleth Metadata Aggregator
  class { 'mda::mda':
    technicalEmail          => $technicalEmail,
    technicalGivenName      => $technicalGivenName,
    technicalSurName        => $technicalSurName,
    federation_name         => $federation_name,
    require                 => Class['mda::prerequisites'],
    notify                  => Service['httpd'],
  }
  
}
