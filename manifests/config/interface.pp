# set the interfaces
define wildfly::config::interface (
  Stdlib::Unixpath                                                $catalina_home,
  Stdlib::Compat::Ip_address                                      $ip_address,
  Enum['management-http','management-https','ajp','http','https'] $ip_type,
) {

  tag(sha1($catalina_home))

  if versioncmp($::facts['augeasversion'], '1.0.0') < 0 {
    fail('Server configurations require Augeas >= 1.0.0')
  }

  augeas { "${catalina_home} ${ip_address} ${ip_type}":
    context => "/files/${catalina_home}/standalone/configuration/standalone.xml",
    lens    => 'Xml.lns',
    incl    => "${catalina_home}/standalone/configuration/standalone.xml",
    changes => "set server/interfaces/interface[#attribute/name= \"${ip_type}\"]/inet-address/#attribute/value ${ip_address}",
  }
}

