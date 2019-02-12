# set the interfaces
define wildfly::config::interface (
  Stdlib::Unixpath               $catalina_home,
  Stdlib::Compat::Ip_address     $ip_address,
  Enum['management','public']    $interface,
) {

  tag(sha1($catalina_home))

  if versioncmp($::facts['augeasversion'], '1.0.0') < 0 {
    fail('Server configurations require Augeas >= 1.0.0')
  }

  augeas { "${catalina_home} ${ip_address} ${interface}":
    context => "/files/${catalina_home}/standalone/configuration/standalone.xml",
    lens    => 'Xml.lns',
    incl    => "${catalina_home}/standalone/configuration/standalone.xml",
    changes => "set server/interfaces/interface[#attribute/name= \"${interface}\"]/inet-address/#attribute/value ${ip_address}",
  }
}

