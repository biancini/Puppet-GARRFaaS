define shib2ds::instance (
   $shibbolethdsversion       = undef,
   $federation_name           = undef,
   $test_federation           = undef,
   $technicalDSadminEmail     = undef,
   $technicalDSadminGivenName = undef,
   $technicalDSadminSurName   = undef,
   $dsfqdn                    = undef,) {
   class { 'shib2ds::prerequisites': dsfqdn => $dsfqdn, }

   # Install and configure Shibboleth SP from Internet2
   class { 'shib2ds::ds':
      shibbolethdsversion       => $shibbolethdsversion,
      require                   => Class['shib2ds::prerequisites'],
      notify                    => Exec['shib2-apache-restart'],
      technicalDSadminEmail     => $technicalDSadminEmail,
      technicalDSadminGivenName => $technicalDSadminGivenName,
      technicalDSadminSurName   => $technicalDSadminSurName,
   }

   # Install and configure Shibboleth SP from Internet2
   class { 'shib2ds::postinstall':
      federation_name => $federation_name,
      test_federation => $test_federation,
      require         => Class['shib2ds::ds'],
      notify          => Exec['shib2-tomcat-restart', 'shib2-apache-restart'],
   }

}
