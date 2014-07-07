define mda::instance (
  $federation_id       = undef,
  $fed_publisher_uri   = undef,
  $federation_country  = undef,
  $use_ca              = undef,
  $test_metadata       = undef,
  $production_metadata = undef,
  $edugain_metadata    = undef,
) {
  
  class { 'mda::prerequisites': }

  # Install and configure Shibboleth Metadata Aggregator
  class { 'mda::mda':
    federation_id       => $federation_id,
    fed_publisher_uri   => $fed_publisher_uri,
    federation_country  => $federation_country,
    use_ca              => $use_ca,
    test_metadata       => $test_metadata,
    production_metadata => $production_metadata,
    edugain_metadata    => $edugain_metadata,
    require             => Class['mda::prerequisites'],
  }
  
}
