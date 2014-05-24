define shib2sp::instance (
  $metadata_information = undef,
  $session_initiator    = undef,
  $apache_doc_root      = undef,
) {
  
  # Install prerequisites
  class { 'shib2sp::prerequisites':
    apache_doc_root => $apache_doc_root,
  }

  # Install and configure Shibboleth SP from Internet2
  class { 'shib2sp::sp':
    metadata_information => $metadata_information,
    session_initiator    => $session_initiator,
    require              => Class['shib2sp::prerequisites'],
    notify               => Exec['shib2-shibd-restart', 'shib2-apache-restart'],
  }

}
