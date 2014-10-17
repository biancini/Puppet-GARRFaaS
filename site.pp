node 'registry.mib.garr.it' {
   # #### GENERAL VARIABLES #####

   # $hostfqdn               = 'registry.mib.garr.it'
   $keystorepassword           = 'puppetpassword'
   $mailto                     = 'admin.idp@mib.garr.it'
   $nagiosserver               = ''

   # #### JAGGER INSTANCE #####

   $rootpw                     = 'ciaoidem'
   $rr3password                = 'ciaorr3'
   $gearmand_version           = undef
   $install_signer             = true
   $federation_logo            = 'https://www.idem.garr.it/documenti/doc_download/66-logo-idem-120-x-70'
   $federation_name            = 'IDEM'
   $jagger_password            = 'i7ryztaqlechgehcs5t7m5iy1ym9xxd4'
   $support_mailto             = 'andrea.biancini@mib.garr.it'
   $registration_authority     = 'http://www.idem.garr.it/'
   $federation_latitude        = '41.8929163'
   $federation_longitude       = '12.4825199'
   $telephone                  = '+39 02 123456'
   $app_environment            = undef

   # #### JAGGER FEDERATION #####

   $federation_domain          = 'garr.it'
   $federation_namespace       = 'urn:mace:garr.it'
   $federation_prod_id         = 'idem'
   $federation_test_id         = 'idem-test'
   $federation_edugain_id      = 'idem-edugain'
   $federation_support         = 'andrea.biancini@mib.garr.it'
   $fed_publisher_uri          = 'https://idem.garr.it/'
   $federation_country         = 'IT'
   $use_ca                     = false

   $fed_prod_name              = "${federation_name} di Produzione"
   $fed_prod_description       = "Federazione ${federation_name} per la comunità italiana"
   $fed_prod_tou               = ''

   $fed_test_name              = "${federation_name} di Test"
   $fed_test_description       = "Federazione ${federation_name} di Test per la comunità italiana"
   $fed_test_tou               = ''

   $fed_edugain_name           = "${federation_name} per eduGAIN"
   $fed_edugain_description    = "Federazione ${federation_name} per la comunità europea"
   $fed_edugain_tou            = ''

   # #### SHIB2SP INSTANCE #####

   $en_orgDisplayName          = 'Test SP for Jagger resource registry'
   $en_communityDesc           = 'GARR Research&amp;Development'
   $en_orgUrl                  = 'http://www.garr.it/'
   $en_privacyPage             = 'http://www.garr.it/'
   $en_nameOrg                 = 'Consortium GARR'
   $en_nameService             = 'Jagger Entity Registry'
   $en_url_LogoOrg_32x32       = 'https://registry.mib.garr.it/idp/images/institutionLogo-32x32_en.png'
   $en_url_LogoOrg_160x120     = 'https://registry.mib.garr.it/idp/images/institutionLogo-160x120_en.png'

   $it_orgDisplayName          = 'SP di test per il resource registry Jagger'
   $it_communityDesc           = 'GARR Ricerca&amp;Sviluppo'
   $it_orgUrl                  = 'http://www.garr.it/'
   $it_privacyPage             = 'http://www.garr.it/'
   $it_nameOrg                 = 'Consortium GARR'
   $it_nameService             = 'Jagger Entity Registry'
   $it_url_LogoOrg_32x32       = 'https://registry.mib.garr.it/idp/images/institutionLogo-32x32_it.png'
   $it_url_LogoOrg_160x120     = 'https://registry.mib.garr.it/idp/images/institutionLogo-160x120_it.png'

   $technicalSPadminEmail      = 'mailto:support@registry.mib.garr.it'
   $technicalSPadminGivenName  = 'Andrea'
   $technicalSPadminSurName    = 'Biancini'
   $technicalSPadminTelephone  = ''

   # #### DISCOJUICE DS INSTANCE #####

   $technicalDSJadminEmail     = 'andrea.biancini@mib.garr.it'
   $technicalDSJadminGivenName = 'Andrea'
   $technicalDSJadminSurName   = 'Biancini'
   $discofeed_url              = 'https://registry.mib.garr.it/Shibboleth.sso/DiscoFeed'

   # ### DON'T EDIT THE LINE BELOW ####

   idpfirewall::firewall { "${hostname}-firewall": iptables_enable_network => undef, }

   $hostfqdn         = 'registry.mib.garr.it'
   $keystorepassword = 'puppetpassword'
   $mailto           = 'admin.idp@mib.garr.it'
   $nagiosserver     = '10.0.0.165'

   shib2common::instance { "${hostname}-common":
      install_apache  => true,
      install_tomcat  => false,
      configure_admin => false,
      hostfqdn        => $hostfqdn,
      mailto          => $mailto,
      nagiosserver    => $nagiosserver,
   }

   shib2sp::instance { "${hostname}-sp":
      metadata_information => {
         'en'             => {
            'orgDisplayName'      => $en_orgDisplayName,
            'communityDesc'       => $en_communityDesc,
            'orgUrl'              => $en_orgUrl,
            'privacyPage'         => $en_privacyPage,
            'nameOrg'             => $en_nameOrg,
            'nameService'         => $en_nameService,
            'url_LogoOrg-32x32'   => $en_url_LogoOrg_32x32,
            'url_LogoOrg-160x120' => $en_url_LogoOrg_160x120,
         }
         ,
         'it'             => {
            'orgDisplayName'      => $it_orgDisplayName,
            'communityDesc'       => $it_communityDesc,
            'orgUrl'              => $it_orgUrl,
            'privacyPage'         => $it_privacyPage,
            'nameOrg'             => $it_nameOrg,
            'nameService'         => $it_nameService,
            'url_LogoOrg-32x32'   => $it_url_LogoOrg_32x32,
            'url_LogoOrg-160x120' => $it_url_LogoOrg_160x120,
         }
         ,
         'technicalSPadminEmail'     => $technicalSPadminEmail,
         'technicalSPadminGivenName' => $technicalSPadminGivenName,
         'technicalSPadminSurName'   => $technicalSPadminSurName,
         'technicalSPadminTelephone' => $technicalSPadminTelephone,
         'attributes'     => [
            {
               'oid'          => 'urn:oid:1.3.6.1.4.1.5923.1.1.1.6',
               'friendlyName' => 'eppn',
               'required'     => true,
            }
            ,
            {
               'oid'          => 'urn:oid:2.5.4.42',
               'friendlyName' => 'givenName',
               'required'     => true,
            }
            ,
            {
               'oid'          => 'urn:oid:0.9.2342.19200300.100.1.3',
               'friendlyName' => 'mail',
               'required'     => true,
            }
            ,
            {
               'oid'          => 'urn:oid:2.5.4.4',
               'friendlyName' => 'sn',
               'required'     => true,
            }
            ,
            {
               'oid'          => 'urn:oid:1.3.6.1.4.1.5923.1.1.1.10',
               'friendlyName' => 'persistent-id',
               'required'     => true,
            }
            ,
            ],
      }
      ,
      session_initiator    => {
         'id'       => 'DS',
         'location' => '/DS',
         'url'      => "https://${fqdn}/disco",
      }
      ,
   }

   jagger::instance { "${hostname}-rr":
      rootpw                 => $rootpw,
      rr3password            => $rr3password,
      gearmand_version       => $gearmand_version,
      install_signer         => $install_signer,
      logo_url               => $federation_logo,
      federation_name        => $federation_name,
      jagger_password        => $jagger_password,
      support_mailto         => $support_mailto,
      registration_authority => $registration_authority,
      federation_latitude    => $federation_latitude,
      federation_longitude   => $federation_longitude,
      telephone              => $telephone,
      app_environment        => $app_environment,
   }

   discojuice::instance { "${hostname}-disco":
      federation_name            => $federation_name,
      discofeed_url              => $discofeed_url,
      technicalDSJadminEmail     => $technicalDSJadminEmail,
      technicalDSJadminGivenName => $technicalDSJadminGivenName,
      technicalDSJadminSurName   => $technicalDSJadminSurName,
      dsfqdn                     => $fqdn,
   }

   mda::instance { "${hostname}-mda":
      federation_id       => $federation_name,
      fed_publisher_uri   => $fed_publisher_uri,
      federation_country  => $federation_country,
      use_ca              => $use_ca,
      test_metadata       => {
         'url' => "https://${fqdn}/rr3/metadata/federation/${federation_test_id}/metadata.xml",
         'urn' => "${federation_namespace}:${federation_test_id}",
      }
      ,
      production_metadata => {
         'url' => "https://${fqdn}/rr3/metadata/federation/${federation_prod_id}/metadata.xml",
         'urn' => "${federation_namespace}:${federation_prod_id}",
      }
      ,
      edugain_metadata    => {
         'url' => "https://${fqdn}/rr3/metadata/federation/${federation_edugain_id}/metadata.xml",
         'urn' => "${federation_namespace}:${federation_edugain_id}",
      }
      ,
   }

   jagger::federation {
      'federation-production':
         rootpw                 => $rootpw,
         federation_id          => $federation_prod_id,
         federation_name        => $fed_prod_name,
         federation_description => $fed_prod_description,
         federation_tou         => $fed_prod_tou,
         domain_name            => $federation_domain;

      'federation-test':
         rootpw                 => $rootpw,
         federation_id          => $federation_test_id,
         federation_name        => $fed_test_name,
         federation_description => $fed_test_description,
         federation_tou         => $fed_test_tou,
         domain_name            => $federation_domain;

      'federation-edugain':
         rootpw                 => $rootpw,
         federation_id          => $federation_edugain_id,
         federation_name        => $fed_edugain_name,
         federation_description => $fed_edugain_description,
         federation_tou         => $fed_edugain_tou,
         domain_name            => $federation_domain
   }
}
