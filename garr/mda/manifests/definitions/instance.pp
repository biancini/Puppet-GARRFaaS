define mda::instance (
  $federation_id       = undef,
  $federation_country  = undef,
  $test_metadata       = undef,
  $production_metadata = undef,
  $edugain_metadata    = undef,
) {
  
  class { 'mda::prerequisites': }

  # Install and configure Shibboleth Metadata Aggregator
  class { 'mda::mda':
    federation_id       => $federation_id,
    federation_country  => $federation_country,
    test_metadata       => $test_metadata,
    production_metadata => $production_metadata,
    edugain_metadata    => $edugain_metadata,
    require             => Class['mda::prerequisites'],
  }
  
}
