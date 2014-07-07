class mda::mda(
  $federation_id           = 'TestFed',
  $fed_publisher_uri       = 'https://idem.garr.it/',
  $federation_country      = 'IT',
  $use_ca                  = false,
  $test_metadata           = {
    'url' => 'https://example.com/registry/test-metadata.xml',
    'urn' => 'urn:mace:garr.it:idem',
  },
  $production_metadata     = {
    'url' => 'https://example.com/registry/production-metadata.xml',
    'urn' => 'urn:mace:garr.it:idem',
  },
  $edugain_metadata     = {
    'url' => 'https://example.com/registry/edugain-metadata.xml',
    'urn' => 'urn:mace:garr.it:idem-edugain',
  },
) {
  
  $fedcountry_downcase = downcase($federation_country)
  $fedid_downcase = downcase($federation_id)
  $fedid_upcase = upcase($federation_id)
  
  file {
    '/opt/ukf-meta/build.xml':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template('mda/build.xml.erb'),
      require => Exec['gitclone ukf-meta'];

    '/opt/ukf-meta/mdx/int_edugain/entity-blacklist.xml':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template('mda/entity-blacklist.xml.erb'),
      require => Exec['gitclone ukf-meta'];
      
    '/opt/ukf-meta/mdx/clean-import.xsl':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      source  => 'puppet:///modules/mda/clean-import.xsl',
      require => Exec['gitclone ukf-meta'];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}":
      ensure  => 'directory',
      recurse => true,
      source  => 'puppet:///modules/mda/my-fed',
      require => Exec['gitclone ukf-meta'];

    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/xsl/addPubInfo.xsl":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template('mda/addPubInfo.xsl.erb'),
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];      

    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/verbs.xml":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template('mda/verbs.xml.erb'),
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/beans.xml":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template('mda/beans.xml.erb'),
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-in":
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];
      
    [
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-in/${fedid_downcase}-edugain",
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-in/${fedid_downcase}-prod",
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-in/${fedid_downcase}-test",
    ]:
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-in"];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-out":
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];
      
    [
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-out/${fedid_downcase}-edugain",
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-out/${fedid_downcase}-prod",
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-out/${fedid_downcase}-test",
    ]:
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-out"];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials":
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials/${fedid_downcase}-selfSigned-cert.pem":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      source  => "puppet:///modules/mda/certs/${hostname}-cert.pem",
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials"];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials/${fedid_downcase}-selfSigned-key.pem":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0400",
      source  => "puppet:///modules/mda/certs/${hostname}-key.pem",
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials"];
  }
  
  if ($use_ca) {
    file {
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials/${fedid_downcase}-signer.key":
	      ensure  => file,
	      owner   => "root",
	      group   => "root",
	      mode    => "0400",
	      source  => "puppet:///modules/mda/certs/${fedid_downcase}-signer-key.pem",
	      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials"];
	      
	    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials/signer-bundle.pem":
	      ensure  => file,
	      owner   => "root",
	      group   => "root",
	      mode    => "0400",
	      source  => "puppet:///modules/mda/certs/${fedid_downcase}-signer-cert.pem",
	      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials"];
      
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials/CA-cert.pem":
	      ensure  => file,
	      owner   => "root",
	      group   => "root",
	      mode    => "0400",
	      source  => "puppet:///modules/mda/certs/${fedid_downcase}-ca.pem",
	      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials"],
    }
  }
  
}
