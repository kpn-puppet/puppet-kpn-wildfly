#
# Configures a datasource
#
define wildfly::datasources::xa_datasource(
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

  $driver_info = split($title, ':')
  $catalina_home = $driver_info[1]

  tag(sha1($catalina_home))

  $profile_path = wildfly::profile_path($target_profile)

  wildfly::resource { "/subsystem=datasources/xa-data-source=${title}:${catalina_home}":
    content   => $config,
    recursive => true,
    profile   => $target_profile,
  }

  -> wildfly::cli { "Enable ${title}:${catalina_home}":
    command => "${profile_path}/subsystem=datasources/xa-data-source=${title}:enable",
    unless  => "(result == true) of ${profile_path}/subsystem=datasources/xa-data-source=${title}:read-attribute(name=enabled)",
  }
}

