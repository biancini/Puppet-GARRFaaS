class shib2ds::ds (
   $dsfqdn                    = 'exampleservername.com',
   $shibbolethdsversion       = '1.2.1',
   $technicalDSadminEmail     = 'user@domain',
   $technicalDSadminGivenName = 'administrator',
   $technicalDSadminSurName   = 'name',) {
   $curtomcat = $::tomcat::curtomcat

   # Download and unpack Shibboleth source files from Internet2 site
   Download_file <| title == "/usr/local/src/shibboleth-discovery-service-${shibbolethdsversion}" |> ~> Shibbolethds_install <| 
   title == 'execute_install' |>

   download_file { "/usr/local/src/shibboleth-discovery-service-${shibbolethdsversion}":
      # url             =>
      # "http://shibboleth.net/downloads/centralized-discovery-service/latest/shibboleth-discovery-service-${shibbolethdsversion}-bin.zip",
      url     => "http://${::pupmaster}/downloads/shibboleth-discovery-service-${shibbolethdsversion}-bin.zip",
      extract => 'zip',
   }

   file {
      '/usr/local/src/shibboleth-discovery-service':
         ensure  => link,
         target  => "/usr/local/src/shibboleth-discovery-service-${shibbolethdsversion}",
         require => Download_file["/usr/local/src/shibboleth-discovery-service-${shibbolethdsversion}"];

      '/usr/local/src/shibboleth-discovery-service/src/installer/resources/build.xml':
         ensure  => present,
         content => template("shib2ds/build.xml.erb"),
         require => File['/usr/local/src/shibboleth-discovery-service'];

      '/usr/local/src/shibboleth-discovery-service/src/main/webapp/images/logo.png':
         ensure  => present,
         source  => "puppet:///modules/shib2ds/logo-idem.png",
         require => File['/usr/local/src/shibboleth-discovery-service'],
         notify  => Shibbolethds_install['execute_install'];

      '/usr/local/src/shibboleth-discovery-service/src/main/webapp/wayf.jsp':
         ensure  => present,
         content => template("shib2ds/wayf.jsp.erb"),
         require => File['/usr/local/src/shibboleth-discovery-service'],
         notify  => Shibbolethds_install['execute_install'];
   }

   # Install the Shibboleth DS
   Shibbolethds_install <| title == 'execute_install' |> ~> Exec['shib2-tomcat-restart']

   shibbolethds_install { 'execute_install':
      dsfqdn     => $dsfqdn,
      javahome   => $shib2common::java::params::java_home,
      tomcathome => $tomcat::tomcat_home,
      curtomcat  => $curtomcat,
      require    => File[
         '/usr/local/src/shibboleth-discovery-service/src/installer/resources/build.xml',
         '/usr/local/src/shibboleth-discovery-service/src/main/webapp/wayf.jsp',
         '/usr/local/src/shibboleth-discovery-service/src/main/webapp/images/logo.png'],
   }

   $dsc_home = '/opt/shibboleth-ds'

   file { "/etc/${curtomcat}/Catalina/localhost/dsc.xml":
      ensure  => present,
      owner   => "${curtomcat}",
      group   => "${curtomcat}",
      mode    => '0644',
      content => template("shib2ds/dsc.xml.erb"),
      notify  => Exec['shib2-tomcat-restart'],
      require => Class['tomcat'],
   }

}
