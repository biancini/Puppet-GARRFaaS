class mda::mda(
  $federation_id       = 'TestFed',
  $federation_country  = 'IT',
) {
  
  $fedcountry_downcase = downcase(federation_country)
  $fedid_downcase = downcase(federation_id)
  
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
      source  => "puppet:///modules/mda/${federation_id}-meta/mdx/clean-import.xsl",
      require => Exec['gitclone ukf-meta'];
      
    "/opt/ukf-meta/mdx/${fedcountry_downcase}_${fedid_downcase}":
      ensure  => folder,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => Exec['gitclone ukf-meta'];
  }
  
}
