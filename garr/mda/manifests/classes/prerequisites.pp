class mda::prerequisites() {

  exec { 'gitclone ukf-meta':
    command => 'git clone https://github.com/ukf/ukf-meta.git',
    cwd     => '/opt',
    require => Package['git'],
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    creates => ['/opt/ukf-meta'];
  }
  
}
