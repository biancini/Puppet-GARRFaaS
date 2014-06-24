class shib2sp::prerequisites(
  $mailto          = "support@${fqdn}",
  $apache_doc_root = "/var/www",
) {

  # Install requested packages
  package { 'libapache2-mod-shib2':
    ensure => installed,
  }
  
  #file { '/usr/lib/apache2/modules/mod_shib.so':
  #  ensure  => link,
  #  target  => '/usr/lib/apache2/modules/mod_shib_22.so',
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #  require => Package['libapache2-mod-shib2'],
  #  before  => Service['apache2'], 
  #}

  file_line { 'sp_environment_rule_4':
    ensure => present,
    path   => '/etc/environment',
    line   => 'SHIB_SP=/etc/shibboleth',
  }

  apache::mod { 'shib':
    lib => 'mod_shib_22.so',
    id  => 'mod_shib',
  }
  
  apache::vhost { 'default-ssl-443':
    servername        => "${fqdn}:443",
    port              => '443',
    serveradmin       => $mailto,
    docroot           => $apache_doc_root,
    ssl               => true,
    ssl_cert          => "${shib2common::certificate::cert_directory}/cert-server.pem",
    ssl_key           => "${shib2common::certificate::cert_directory}/key-server.pem",
    ssl_chain         => "${shib2common::certificate::cert_directory}/Terena-chain.pem",
    add_listen        => true,
    error_log         => true,
    error_log_file    => 'error.log',
    access_log        => true,
    access_log_file   => 'ssl_access.log',
    access_log_format => 'combined',
    custom_fragment   => '
<Directory /usr/lib/cgi-bin>
   SSLOptions +StdEnvVars
</Directory>

#   SSL Protocol Adjustments:
#   The safe and default but still SSL/TLS standard compliant shutdown
#   approach is that mod_ssl sends the close notify alert but doesn\'t wait for
#   the close notify alert from client. When you need a different shutdown
#   approach you can use one of the following variables:
#   o ssl-unclean-shutdown:
#     This forces an unclean shutdown when the connection is closed, i.e. no
#     SSL close notify alert is send or allowed to received.  This violates
#     the SSL/TLS standard but is needed for some brain-dead browsers. Use
#     this when you receive I/O errors because of the standard approach where
#     mod_ssl sends the close notify alert.
#   o ssl-accurate-shutdown:
#     This forces an accurate shutdown when the connection is closed, i.e. a
#     SSL close notify alert is send and mod_ssl waits for the close notify
#     alert of the client. This is 100% SSL/TLS standard compliant, but in
#     practice often causes hanging connections with brain-dead browsers. Use
#     this only for browsers where you know that their SSL implementation
#     works correctly.
#   Notice: Most problems of broken clients are also related to the HTTP
#   keep-alive facility, so you usually additionally want to disable
#   keep-alive for those clients, too. Use variable "nokeepalive" for this.
#   Similarly, one has to force some clients to use HTTP/1.0 to workaround
#   their broken HTTP/1.1 implementation. Use variables "downgrade-1.0" and
#   "force-response-1.0" for this.
BrowserMatch "MSIE [2-6]" \
   nokeepalive ssl-unclean-shutdown \
   downgrade-1.0 force-response-1.0
# MSIE 7 and newer should be able to use keepalive
BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
',
    require           => Class['apache::mod::ssl', 'shib2common::certificate'],
}

  file {
    '/var/www/secure':
      ensure       => directory,
      mode         => '0644',
      owner        => 'root',
      group        => 'root';

    '/var/www/secure/index.php':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "644",
      source  => "puppet:///modules/shib2sp/index.php",
      notify  => Exec['shib2-shibd-restart'],
      require => File['/var/www/secure'];

    '/var/www/secure/pam.php':
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => "644",
      source  => "puppet:///modules/shib2sp/pam.php",
      notify  => Exec['shib2-shibd-restart'],
      require => File['/var/www/secure'];
    
    '/etc/apache2/sites-available/secure.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => [join(['<Location /secure>',
                        '    AuthType shibboleth',
                        '    ShibRequireSession On',
                        '    require valid-user',
                        '    SSLRequireSSL',
                        '</Location>'], "\n")],
      require => Apache::Mod['shib'],
      notify  => Exec['shib2-apache-restart'];

    '/etc/apache2/sites-enabled/secure.conf':
      ensure  => link,
      target  => '/etc/apache2/sites-available/secure.conf',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['/etc/apache2/sites-available/secure.conf'],
      notify  => Exec['shib2-apache-restart'];
      
  }
}
