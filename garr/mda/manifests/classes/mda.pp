class mda::mda(
  $federation_id           = 'TestFed',
  $federation_country      = 'IT',
  $test_metadata     = {
    'url' => 'http://example.com/registry/test-metadata.xml',
    'urn' => 'urn:mace:garr:it:idem',
  },
  $production_metadata     = {
    'url' => 'http://example.com/registry/production-metadata.xml',
    'urn' => 'urn:mace:garr:it:idem',
  },
  $edugain_metadata     = {
    'url' => 'http://example.com/registry/edugain-metadata.xml',
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
    
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}/xsl/removeIdemEntityFromEdugainMetadata.xsl":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template('mda/removeIdemEntityFromEdugainMetadata.xsl.erb'),
      require => File["/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}"];  
  }
  
}
