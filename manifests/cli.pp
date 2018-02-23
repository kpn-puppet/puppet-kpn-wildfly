#
# Executes an arbitrary JBoss-CLI command
#   `[node-type=node-name (/node-type=node-name)*] : operation-name ['('[name=value [, name=value]*]')'] [{header (;header)*}]`.
#   This define is a wrapper for `wildfly_cli` that defaults to your local Wildfly installation.
#
# @param command The actual command to execute.
# @param unless If this parameter is set, then this `cli` will only run if this command condition is met.
# @param onlyif If this parameter is set, then this `cli` will run unless this command condition is met.
define wildfly::cli(
  Hash[Enum['username','password'], String]                                            $mgmt_user,
  Hash[Enum['management-http','management-https','ajp','http','https'], Integer[1024]] $port_properties,
  Hash[Enum['management','public'], Stdlib::Compat::Ip_address]                        $ip_properties,
  String                                                                               $command = $title,
  Optional[String]                                                                     $unless = undef,
  Optional[String]                                                                     $onlyif = undef,
) {

  $cli_info = split($title, ':')
  $cli = $cli_info[0]
  $catalina_home = $cli_info[1]

  wildfly_cli { $cli:
    command  => $command,
    username => $mgmt_user['username'],
    password => $mgmt_user['password'],
    host     => $ip_properties['management'],
    port     => $port_properties['management-http'],
    unless   => $unless,
    onlyif   => $onlyif,
  }
}
