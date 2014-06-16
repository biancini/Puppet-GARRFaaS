define mda::instance (
  $federation_id      = undef,
  $federation_country = undef,
) {
  
  class { 'mda::prerequisites': }

  # Install and configure Shibboleth Metadata Aggregator
  class { 'mda::mda':
    federation_id      => $federation_id,
    federation_country => $federation_country,
    require            => Class['mda::prerequisites'],
  }
  
}
