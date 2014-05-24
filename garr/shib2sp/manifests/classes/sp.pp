class shib2sp::sp(
  $metadata_information = undef,
  $session_initiator    = {'id' => 'Intranet', 'location' => '/Login', 'url' => 'https://idp.example.com/idp/shibboleth'},
) {
  
  # Download the signer budnle from IDEM federation
  # download_file { '/etc/shibboleth/signer_bundle.pem':
  #   url => "https://www.idem.garr.it/index.php/it/documenti/doc_download/45-signerbundle",
  # }

  file { '/etc/shibboleth':
    ensure  => present,
    owner   => "_shibd",
    group   => "root",
    mode    => "755",
    require => Package['libapache2-mod-shib2']
  }

  download_file { '/etc/shibboleth/idem-metadata-signer.pem':
    url     => "https://www.idem.garr.it/documenti/doc_download/321-idem-metadata-signer-2019",
    require => File['/etc/shibboleth'],
  }
  
  exec { 'generate-sp-certs':
    command => 'shib-keygen',
    path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
    creates => ['/etc/shibboleth/sp-cert.pem', '/etc/shibboleth/sp-key.pem'],
    require => Package['libapache2-mod-shib2'],
  }
  
  file {
    '/etc/shibboleth/shibboleth2.xml':
	    ensure  => file,
	    owner   => "root",
	    group   => "root",
	    mode    => "644",
	    content => template("shib2sp/shibboleth2.xml.erb"),
	    require => File['/etc/shibboleth'];
	    
    '/etc/shibboleth/attribute-map.xml':
      ensure  => file,
      owner   => "root",
	    group   => "root",
	    mode    => "644",
	    source  => "puppet:///modules/shib2sp/attribute-map.xml",
	    require => File['/etc/shibboleth'];
  }
  
}
