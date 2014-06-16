define mda::instance (
  $federation_name    = undef,
) {
  
  class { 'mda::prerequisites': }

  # Install and configure Shibboleth Metadata Aggregator
  class { 'mda::mda':
    federation_name         => $federation_name,
    require                 => Class['mda::prerequisites'],
  }
  
}
