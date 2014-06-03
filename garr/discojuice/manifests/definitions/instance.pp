define discojuice::instance (
  $federation_name = undef,
  $test_federation = undef,
  $technicalEmail = undef,
  $technicalGivenName = undef,
  $technicalSurName = undef,
  $dsfqdn = undef,
) {
  
  class { 'discojuice::prerequisites':
    dsfqdn                  => $dsfqdn,
  }

  # Install and configure Shibboleth SP from Internet2
  class { 'discojuice::ds':
    require                 => Class['shib2ds::prerequisites'],
    notify                  => Exec['shib2-apache-restart'],
    technicalEmail          => $technicalEmail,
    technicalGivenName      => $technicalGivenName,
    technicalSurName        => $technicalSurName,
  }
  
  # Install and configure Shibboleth SP from Internet2
  class { 'discojuice::postinstall':
    federation_name         => $federation_name,
    test_federation         => $test_federation,
    require                 => Class['discojuice::ds'],
    notify                  => Exec['discojuice-apache-restart'],
  }
 
}
