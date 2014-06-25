node 'registry.mib.garr.it' {
  idpfirewall::firewall { "${hostname}-firewall": 
      iptables_enable_network => undef,
  }

  $hostfqdn                = 'registry.mib.garr.it'
  $keystorepassword        = 'puppetpassword'
  $mailto                  = 'admin.idp@mib.garr.it'
  $nagiosserver            = '10.0.0.165'

  shib2common::instance { "${hostname}-common":
    install_apache          => true,
    install_tomcat          => false,
    configure_admin         => false,
    hostfqdn                => $hostfqdn,
    mailto                  => $mailto,
    nagiosserver            => $nagiosserver,
  }

  shib2sp::instance { "${hostname}-sp":
    metadata_information    => {
      'en'                => {
        'orgDisplayName'         => 'Test SP for Jagger resource registry',
        'communityDesc'          => 'GARR Research&amp;Development',
        'orgUrl'                 => 'http://www.garr.it/',
        'nameOrg'                => 'Consortium GARR',
	'nameService'            => 'Jagger',
        'url_LogoOrg-32x32'      => 'https://registry.mib.garr.it/idp/images/logoEnte-32x32_en.png',
        'url_LogoOrg-160x120'    => 'https://registry.mib.garr.it/idp/images/logoEnte-160x120_en.png',
      },
      'it'                => {
        'orgDisplayName'         => 'SP di test per il resource registry Jagger',
        'communityDesc'          => 'GARR Research&amp;Development',
        'orgUrl'                 => 'http://www.garr.it/',
        'privacyPage'            => 'http://www.garr.it/',
        'nameOrg'                => 'Consortium GARR',
	'nameService'            => 'Jagger',
        'url_LogoOrg-32x32'      => 'https://registry.mib.garr.it/idp/images/logoEnte-32x32_it.png',
        'url_LogoOrg-160x120'    => 'https://registry.mib.garr.it/idp/images/logoEnte-160x120_it.png',
      },
      'technicalEmail'             => 'mailto:support@registry.mib.garr.it',
      'technicalIDPadminGivenName' => 'GivenName',
      'technicalIDPadminSurName'   => 'SurName',
      'technicalIDPadminTelephone' => '',
      'attributes'                 => [
        {
          'oid'          => 'urn:oid:1.3.6.1.4.1.5923.1.1.1.6',
          'friendlyName' => 'eppn',
          'required'     => true,
        },
        {
          'oid'          => 'urn:oid:2.5.4.42',
          'friendlyName' => 'givenName',
          'required'     => true,
        },
        {
          'oid'          => 'urn:oid:0.9.2342.19200300.100.1.3',
          'friendlyName' => 'mail',
          'required'     => true,
        },
        {
          'oid'          => 'urn:oid:2.5.4.4',
          'friendlyName' => 'sn',
          'required'     => true,
        },
        {
          'oid'          => 'urn:oid:1.3.6.1.4.1.5923.1.1.1.10',
          'friendlyName' => 'persistent-id',
          'required'     => true,
        },
      ],
    },
    session_initiator           => {
      'id'        => 'DS',
      'location'  => '/DS',
      'url'       => "https://${fqdn}/rr3/eds",
    },
  }

  $rootpw          = 'ciaoidem'
  $federation_id   = 'IDEM'
  $federation_name = 'Federazione IDEM'

  jagger::instance { "${hostname}-rr":
    rootpw                 => $rootpw,
    rr3password            => 'ciaorr3',
    gearmand_version       => undef,
    install_signer         => true,
    logo_url               => 'https://www.idem.garr.it/documenti/doc_download/66-logo-idem-120-x-70',
    federation_name        => $federation_id,
    jagger_password        => 'i7ryztaqlechgehcs5t7m5iy1ym9xxd4',
    support_mailto         => 'andrea@mib.garr.it',
    registration_authority => 'http://www.idem.garr.it/',
    federation_latitude    => '41.8929163',
    federation_longitude   => '12.4825199',
    telephone              => '+39 02 123456',
    app_environment        => undef,
  }

  discojuice::instance { "${hostname}-disco":
    federation_name    => $federation_id,
    discofeed_url      => 'https://registry.mib.garr.it/Shibboleth.sso/DiscoFeed',
    technicalEmail     => 'andrea@mib.garr.it',
    technicalGivenName => 'Andrea',
    technicalSurName   => 'Biancini',
    dsfqdn             => $fqdn,
  }

  $federation_test_b64 = chomp(regsubst(base64('encode', "${federation_name} di test"), '=', '~', 'G'))
  $federation_prod_b64 = chomp(regsubst(base64('encode', "${federation_name} di produzione"), '=', '~', 'G'))
  $federation_edugain_b64 = chomp(regsubst(base64('encode', "${federation_name} per eduGAIN"), '=', '~', 'G'))

  mda::instance { "${hostname}-mda":
    federation_id           => $federation_id,
    federation_country      => 'IT',
    use_ca                  => true,
    test_metadata           => {
      'url' => "https://${fqdn}/rr3/metadata/federation/${federation_test_b64}/metadata.xml",
      'urn' => 'urn:mace:garr:it:idem',
    },
    production_metadata     => {
      'url' => "https://${fqdn}/rr3/metadata/federation/${federation_prod_b64}/metadata.xml",
      'urn' => 'urn:mace:garr:it:idem',
    },
    edugain_metadata        => {
      'url' => "https://${fqdn}/rr3/metadata/federation/${federation_edugain_b64}/metadata.xml",
      'urn' => 'urn:mace:garr:it:idem-edugain',
    },
  }

  jagger::federation {
    'federation-production':
      rootpw                 => $rootpw,
      federation_id          => $federation_id,
      federation_name        => "${federation_name} di produzione",
      federation_description => 'Federazione IDEM per la comunità italiana',
      federation_tou         => '',
      domain_name            => 'garr.it';

    'federation-test':
      rootpw                 => $rootpw,
      federation_id          => "${federation_id}-TEST",
      federation_name        => "${federation_name} di test",
      federation_description => 'Federazione IDEM per la comunità italiana',
      federation_tou         => '',
      domain_name            => 'garr.it';

    'federation-edugain':
      rootpw                 => $rootpw,
      federation_id          => "${federation_id}-EDUGAIN",
      federation_name        => "${federation_name} per eduGAIN",
      federation_description => 'Federazione IDEM per la comunità italiana',
      federation_tou         => '',
      domain_name            => 'garr.it';
  }
}
