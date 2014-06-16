class mda::mda(
  $federation_id           = 'TestFed',
  $federation_country      = 'IT',
  $ca_cert                 = 'https://example.com/ca-cert.pem',
  $signer_bundle           = 'https://example.com/signer-bundle.pem',
  $test_metadata           = {
    'url' => 'https://example.com/registry/test-metadata.xml',
    'urn' => 'urn:mace:garr:it:idem',
  },
  $production_metadata     = {
    'url' => 'https://example.com/registry/production-metadata.xml',
    'urn' => 'urn:mace:garr:it:idem',
  },
  $edugain_metadata     = {
    'url' => 'https://example.com/registry/edugain-metadata.xml',
    'urn' => 'urn:mace:garr:it:idem-edugain',
  },
) {
  
  $fedcountry_downcase = downcase($federation_country)
  $fedid_downcase = downcase($federation_id)
  
  file {
    '/opt/ukf-meta/build.xml':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template('mda/build.xml.erb'),
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
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/verbs.xml":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template('mda/verbs.xml.erb'),
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];
    
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/xsl/remove${federation_id}EntityFromEdugainMetadata.xsl":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template('mda/removeEntityFromEdugainMetadata.xsl.erb'),
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-in":
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];
      
    [
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-in/${fedcountry_downcase}-edugain",
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-in/${fedcountry_downcase}-prod",
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-in/${fedcountry_downcase}-test",
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
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-out/${fedcountry_downcase}-edugain",
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-out/${fedcountry_downcase}-prod",
      "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/md-out/${fedcountry_downcase}-test",
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
  }
  
  download_file {
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials/signer_bundle.pem":
      url     => $signer_bundle,
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials"];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials/CA-cert.pem":
      url     => $ca_cert,
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/credentials"];
  }
  
}
