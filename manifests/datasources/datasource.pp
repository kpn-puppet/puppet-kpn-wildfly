#
# Configures a datasource
#
define wildfly::datasources::datasource(
  Optional[Hash]                                                                                 $config = undef,
  Optional[String]                                                                               $target_profile = undef,
  Optional[Hash[Enum['username','password'], String]]                                            $mgmt_user = undef,
  Optional[Hash[Enum['management-http','management-https','ajp','http','https'], Integer[1024]]] $port_properties = undef,
  Optional[Hash[Enum['management','public'], Stdlib::Compat::Ip_address]]                        $ip_properties = undef,
) {

  include ::wildfly
  $_mgmt_user = pick($mgmt_user, $::wildfly::mgmt_user)
  $_port_properties = pick($port_properties, $::wildfly::port_properties)
  $_ip_properties = pick($ip_properties, $::wildfly::ip_properties)

  $datasource_info = split($title, ':')
  $datasource = $datasource_info[0]
  $catalina_home = $datasource_info[1]

  tag(sha1($catalina_home))

  $profile_path = wildfly::profile_path($target_profile)

  wildfly::resource { "/subsystem=datasources/data-source=${datasource}:${catalina_home}":
    content         => $config,
    profile         => $target_profile,
    mgmt_user       => $_mgmt_user,
    port_properties => $_port_properties,
    ip_properties   => $_ip_properties,
  }
  -> wildfly::cli { "Enable ${datasource} for ${catalina_home}":
    command         => "${profile_path}/subsystem=datasources/data-source=${datasource}:enable",
    mgmt_user       => $_mgmt_user,
    port_properties => $_port_properties,
    ip_properties   => $_ip_properties,
    unless          => "(result == true) of ${profile_path}/subsystem=datasources/data-source=${datasource}:read-attribute(name=enabled)",
  }
}

