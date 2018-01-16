#
# Configures connection property in a database
#
define wildfly::datasources::db_property(
  String                                                                                         $database,
  Optional[String]                                                                               $value = undef,
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

  $params = {
    'value' => $value,
  }

  wildfly::resource { "/subsystem=datasources/data-source=${database}/connection-properties=${title}:${catalina_home}":
    content         => $params,
    profile         => $target_profile,
    mgmt_user       => $_mgmt_user,
    port_properties => $_port_properties,
    ip_properties   => $_ip_properties,
  }
}

