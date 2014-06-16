class mda::mda(
  $federation_id       = 'TestFed',
  $federation_country  = 'IT',
) {
  
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
      
    "/opt/ukf-meta/mdx/${downcase(federation_country)}_${downcase(federation_id)}":
      ensure  => folder,
      owner   => "root",
      group   => "root",
      mode    => "0755",
      require => Exec['gitclone ukf-meta'];
  }
  
}
