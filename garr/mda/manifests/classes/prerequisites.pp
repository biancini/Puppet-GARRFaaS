class mda::prerequisites() {

  file { '/opt/mda':
    ensure  => directory;
  }
  
  exec {
	  'gitclone ukf-meta':
	      command => 'git clone https://github.com/ukf/ukf-meta.git',
	      cwd     => '/opt/mda',
	      require => [Package['git'], File['/opt/mda']],
	      path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
	      creates => ['/opt/mda/ukf-meta'];
  }
}
