#
# Configures a driver
#
define wildfly::datasources::driver(
  String                                                                                         $driver_name,
  String                                                                                         $driver_module_name,
  Optional[String]                                                                               $driver_class_name = undef,
  Optional[String]                                                                               $driver_xa_datasource_class_name = undef,
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

  $params = {
    'driver-name' => $driver_name,
    'driver-module-name' => $driver_module_name,
    'driver-class-name' => $driver_class_name,
    'driver-xa-datasource-class-name' => $driver_xa_datasource_class_name,
  }

  wildfly::resource { "/subsystem=datasources/jdbc-driver=${driver_name}:${catalina_home}":
    content         => $params,
    profile         => $target_profile,
    mgmt_user       => $_mgmt_user,
    port_properties => $_port_properties,
    ip_properties   => $_ip_properties,
  }
}

