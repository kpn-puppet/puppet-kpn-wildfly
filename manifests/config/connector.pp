# set the connectors
define wildfly::config::connector (
  Stdlib::Unixpath $catalina_home,
  String           $connector_name,
  Integer[1024]    $connector_port,
) {

  tag(sha1($catalina_home))

  if versioncmp($::facts['augeasversion'], '1.0.0') < 0 {
    fail('Server configurations require Augeas >= 1.0.0')
  }
  augeas { "${catalina_home} ${connector_name}":
    context => "/files/${catalina_home}/standalone/configuration/standalone.xml",
    lens    => 'Xml.lns',
    incl    => "${catalina_home}/standalone/configuration/standalone.xml",
    changes => "set server/socket-binding-group/socket-binding[#attribute/name=\"${connector_name}\"]/#attribute/port ${connector_port}",
  }
}

