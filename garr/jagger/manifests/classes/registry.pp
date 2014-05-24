class jagger::registry(
  $rootpw                 = 'puppetsecret',
  $federation_name        = 'FEDERATION',
  $jagger_password        = 'b33exf4q0h5j6xus35xo91d109jnzk5i',
  $support_mailto         = 'support@example.com',
  $registration_authority = 'http://the-authority.example.com',
  $federation_latitude    = '41.8929163',
  $federation_longitude   = '12.4825199',
  $telephone              = '555-1234',
  $rr3password            = 'rr3secret',
  $admin_mail             = 'admin@example.com',
  $admin_name             = 'Name',
  $admin_surname          = 'Surname',
  $app_environment        = 'development',
) {
  
  file {
    '/opt/rr3/application/config/config_rr.php':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template("jagger/config_rr.php.erb"),
      require => Exec['gitclone rr3'];
      
    '/opt/rr3/application/config/email.php':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template("jagger/email.php.erb"),
      require => Exec['gitclone rr3'];
      
    '/opt/rr3/application/config/database.php':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      content => template("jagger/database.php.erb"),
      require => Exec['gitclone rr3'];
          
    '/opt/rr3/application/logs':
      owner   => 'www-data',
      require => Exec['gitclone rr3'];
      
    '/etc/init.d/jaggermailer':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      source  => "puppet:///modules/jagger/scripts/jaggermailer",
      require => Exec['copy index.php'];
  }
  
  exec {
    'jagger conf config.php':
      command => "cp config-default.php config.php",
      cwd     => "/opt/rr3/application/config",
      path    => ["/bin", "/usr/bin"],
      creates => ["/opt/rr3/application/config/config.php"],
      require => Exec['install rr3'];
      
    'copy memcached.php':
      command => 'cp memcached-default.php memcached.php',
      cwd     => '/opt/rr3/application/config',
      require => Exec['gitclone rr3'],
      path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
      creates => ['/opt/rr3/application/config/memcached.php'];
      
    'doctrine schema create':
      command => 'php doctrine orm:schema-tool:create',
      cwd     => '/opt/rr3/application',
      require => [Exec['jagger conf config.php'], File['/opt/rr3/application/config/database.php', '/opt/rr3/application/config/email.php', '/opt/rr3/application/config/config_rr.php']],
      path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
      unless  => "mysqlshow -u root -p${rootpw} rr3 | grep \"| queue\"",
      notify  => Service['httpd'];
      
    'doctrine generate proxies':
      command => 'php doctrine orm:generate-proxies',
      cwd     => '/opt/rr3/application',
      require => [Exec['jagger conf config.php'], File['/opt/rr3/application/config/database.php', '/opt/rr3/application/config/email.php', '/opt/rr3/application/config/config_rr.php']],
      path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
      creates => ['/opt/rr3/application/models/Proxies/__CG__modelsQueue.php'],
      notify  => Service['httpd'];
  }
  
  $random_key = randomstring(32)
  modifyfilelines {
    'modify config.php baseurl':
      modifyname => 'baseurl',
      filename   => 'config.php',
      filepath   => '/opt/rr3/application/config',
      search     => '\$config\[\'base_url\'\].*= \'\'',
      replace    => "\\\$config\\['base_url'\\] = 'https:\\/\\/${fqdn}\\/rr3'",
      require    => Exec['jagger conf config.php'];
      
    'modify config.php encryption_key':
      modifyname => 'encryption_key',
      filename   => 'config.php',
      filepath   => '/opt/rr3/application/config',
      search     => '\$config[\'encryption_key\'] = \'jhiufhi34hfhewhfsdfhsd\'',
      replace    => "\\\$config\\['encryption_key'\\] = '${random_key}'",
      search_new => false,
      require    => Exec['jagger conf config.php'];

    'modify index.php app_environment':
      filename   => 'index.php',
      filepath   => '/opt/rr3',
      search     => '\$_SERVER\[\'CI_ENV\'\] : \'.*\'',
      replace    => "\\\$_SERVER\\['CI_ENV'\\] : '${app_environment}'",
      require    => Exec['copy index.php'];
  }
  
  $pwd_salt = randomstring(10)
  $encrypted_pwd = sha1("${rootpw}${pwd_salt}")
  $front_page = join(split(template('jagger/front-page.erb'), '\n'), ' ')
  execute_mysql {
    'rr3 setup database':
      user              => 'root',
      password          => $rootpw,
      dbname            => 'rr3',
      query_check_empty => 'SELECT * FROM user WHERE username = \'admin\'',
      sql               => [template('jagger/rr3_database_script.sql.erb')],
      require           => Exec['doctrine schema create', 'doctrine generate proxies'];

    'rr3 static front page':
      user              => 'root',
      password          => $rootpw,
      dbname            => 'rr3',
      query_check_empty => 'SELECT * FROM staticpage WHERE pcode = \'front_page\'',
      sql => [join(['INSERT INTO staticpage (id, pcode, pcategory, ptitle, ptext, ispublic, enabled, created_at, updated_at) VALUES (',
                    'NULL, ',
                    '\'front_page\', ',
                    '\'global\', ',
                    "'${federation_name} Entity Registry', ",
                    "'${front_page}', ",
                    '\'1\', ',
                    '\'1\', ',
                    'NOW(), ',
                    'NOW());'], ' ')],
      require           => Exec['doctrine schema create', 'doctrine generate proxies'];      
  }

  

}
