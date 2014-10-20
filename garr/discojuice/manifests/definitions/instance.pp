define discojuice::instance (
   $federation_name            = undef,
   $discofeed_url              = undef,
   $technicalDSJadminEmail     = undef,
   $technicalDSJadminGivenName = undef,
   $technicalDSJadminSurName   = undef,
   $dsfqdn                     = undef,) {
   class { 'discojuice::prerequisites':
      dsfqdn        => $dsfqdn,
      discofeed_url => $discofeed_url,
   }

   # Install and configure Discojuice DS
   class { 'discojuice::ds':
      technicalDSJadminEmail     => $technicalDSJadminEmail,
      technicalDSJadminGivenName => $technicalDSJadminGivenName,
      technicalDSJadminSurName   => $technicalDSJadminSurName,
      federation_name            => $federation_name,
      require                    => Class['discojuice::prerequisites'],
      notify                     => Service['httpd'],
   }

}
