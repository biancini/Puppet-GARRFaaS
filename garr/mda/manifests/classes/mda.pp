class mda::mda(
  $federation_name     = 'Test Federation',
) {
  
  file {
    '/opt/mda/ukf-meta/build.xml':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      source  => "puppet://mda/${federation_name}-meta/build.xml",
      require => Exec['gitclone ukf-meta'];
      
    '/opt/mda/ukf-meta/mdx/clean-import.xsl':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      source  => "puppet://mda/${federation_name}-meta/mdx/clean-import.xsl",
      require => Exec['gitclone ukf-meta'];
      
    #'/opt/mda/ukf-meta/mdx/it_idem':
    #  recurse => true,
    #  source  => "puppet://mda/${federation_name}-meta/mdx/it_idem",
    #  require => Exec['gitclone ukf-meta'];
  }
  
}
