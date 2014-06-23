define jagger::instance (
  $rootpw                 = undef,
  $rr3password            = undef,
  $gearmand_version       = undef,
  $install_signer         = undef,
  $logo_url               = undef,
  $federation_name        = undef,
  $jagger_password        = undef,
  $support_mailto         = undef,
  $registration_authority = undef,
  $federation_latitude    = undef,
  $federation_longitude   = undef,
  $telephone              = undef,
  $admin_mail             = undef,
  $admin_name             = undef,
  $admin_surname          = undef,
  $install_phpmyadmin     = undef,
  $app_environment        = undef,
) {
  
  # A Jagger Federation can be registered only AFTER the registry has been installed correctly
  Jagger::Registry <| |> -> Jagger::Federation <| |>
  
  # Install prerequisites
  class { 'jagger::prerequisites':
    rootpw           => $rootpw,
    rr3password      => $rr3password,
    gearmand_version => $gearmand_version,
    install_signer   => $install_signer,
    logo_url         => $logo_url,
  }

  # Install and configure Jagger from Internet2
  class { 'jagger::registry':
    rootpw                 => $rootpw,
    federation_name        => $federation_name,
    jagger_password        => $jagger_password,
    support_mailto         => $support_mailto,
    registration_authority => $registration_authority,
    federation_latitude    => $federation_latitude,
    federation_longitude   => $federation_longitude,
    rr3password            => $rr3password,
    admin_mail             => $admin_mail,
    admin_name             => $admin_name,
    admin_surname          => $admin_surname,
    app_environment        => $app_environment,
    require                => Class['jagger::prerequisites'],
    notify                 => Service['httpd'],
  }

}
