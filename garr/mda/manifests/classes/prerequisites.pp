class mda::prerequisites() {

  package { "ant":
    ensure => installed,  
  }

  exec { 'gitclone ukf-meta':
    command => 'git clone https://github.com/ukf/ukf-meta.git',
    cwd     => '/opt',
    require => Package['git'],
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    creates => ['/opt/ukf-meta'];
  }
  
  file {
    '/etc/apache2/sites-available/mda.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => [join(['   Alias /mda /opt/ukf-meta/mdx/it_idem/md-out',
                        '',
                        '   <Directory /opt/ukf-meta/mdx/it_idem/md-out>',
                        '     Options Indexes FollowSymLinks MultiViews',
                        '     AllowOverride All',
                        '     Order allow,deny',
                        '     allow from all',
                        '   </Directory>'], "\n")],
      require => Class['apache'],
      notify  => Exec['shib2-apache-restart'];

    '/etc/apache2/sites-enabled/mda.conf':
      ensure  => link,
      target  => '/etc/apache2/sites-available/mda.conf',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['/etc/apache2/sites-available/mda.conf'],
      notify  => Exec['shib2-apache-restart'];
  }
  
}
