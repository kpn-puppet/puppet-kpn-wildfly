# definition wildfly::instance
# ===========================
define wildfly::instance (
  Optional[Stdlib::Unixpath] $catalina_home          = undef,
  Optional[String]           $user                   = undef,
  Optional[String]           $group                  = undef,
  Optional[Boolean]          $manage_user            = undef,
  Optional[Boolean]          $manage_group           = undef,
  Optional[Boolean]          $manage_service         = true,
  Optional[Hash[Enum['management-http','management-https','ajp','http','https'], Integer[1024]]]
    $port_properties                                 = undef,
  Optional[Hash[Enum['management','public'], Stdlib::Compat::Ip_address]]
    $ip_properties                                   = undef,
  Optional[Stdlib::Unixpath] $java_home              = undef,
  Optional[String]           $java_opts              = undef,
  Optional[String]           $java_xms               = '256m',
  Optional[String]           $java_xmx               = '512m',
  Optional[Boolean]          $remote_debug           = false,
  Optional[Integer[1024]]    $remote_debug_port      = 8787,
) {
  include ::wildfly
  $_catalina_home = pick($catalina_home, $::wildfly::catalina_home)
  tag(sha1($_catalina_home))
  $_user = pick($user, $::wildfly::user)
  $_group = pick($group, $::wildfly::group)
  $_manage_user = pick($manage_user, $::wildfly::manage_user)
  $_manage_group = pick($manage_group, $::wildfly::manage_group)

  wildfly::instance::dependencies { $name:
    catalina_home => $_catalina_home,
  }

  file { "${_catalina_home}/bin/standalone.conf":
    ensure  => 'file',
    owner   => $_user,
    group   => $_group,
    mode    => '0644',
    content => epp('wildfly/standalone.conf.epp', {
      'java_opts'         => $java_opts,
      'java_xms'          => $java_xms,
      'java_xmx'          => $java_xmx,
      'remote_debug'      => $remote_debug,
      'remote_debug_port' => $remote_debug_port,
      }),
  }

  if $manage_service {
    wildfly::service { $name:
      catalina_home  => $_catalina_home,
      java_home      => $java_home,
      service_ensure => 'running',
      service_enable => $manage_service,
      user           => $_user,
      group          => $_group,
      subscribe      => File["${_catalina_home}/bin/standalone.conf"],
    }
  }
  if $port_properties {
    $port_properties.each |$_connector_name,$_connector_port| {
      wildfly::config::connector { "${_catalina_home} ${_connector_name} standalone.xml":
        catalina_home  => $_catalina_home,
        connector_name => $_connector_name,
        connector_port => $_connector_port,
      }
    }
  }
  if $ip_properties {
    $ip_properties.each |$_ip_type,$_ip_address| {
      wildfly::config::interface { "${_catalina_home} ${_ip_type} standalone.xml":
        catalina_home => $_catalina_home,
        ip_address    => $_ip_address,
        ip_type       => $_ip_type,
      }
    }
  }
  wildfly::user::mgmt_user { "${wildfly::mgmt_user['username']}:${_catalina_home}":
    password => $wildfly::mgmt_user['password'],
  }
}
