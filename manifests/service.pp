# class: wildfly
# ===========================
define wildfly::service (
  Enum['running', 'stopped'] $service_ensure                   = 'running',
  Boolean                    $service_enable                   = true,
  String                     $service_name                     = $title,
  Optional[Stdlib::Unixpath] $catalina_home                    = undef,
  Optional[Stdlib::Unixpath] $java_home                        = undef,
  Optional[String]           $user                             = undef,
  Optional[String]           $group                            = undef,
) {
  include ::wildfly
  $_user = pick($user, $::wildfly::user)
  $_group = pick($group, $::wildfly::group)

  case $facts['os']['release']['major'] {
    '6': {
      $_startupfile = 'initd'
      $_startupdir = '/etc/init.d'
      $_startupext = undef
    }
    default: {
      $_startupfile = 'systemd'
      $_startupdir = '/etc/systemd/system'
      $_startupext = '.service'
    }
  }

  tag(sha1($catalina_home))

  ensure_resource('file', '/etc/wildfly', { ensure => 'directory' })

  file { "${catalina_home}/bin/launch.sh":
    ensure => file,
    owner  => $_user,
    group  => $_group,
    mode   => '0755',
    source => 'puppet:///modules/wildfly/launch.sh',
  }

  file { "/etc/wildfly/${name}.conf":
    ensure  => file,
    owner   => $_user,
    group   => $_group,
    mode    => '0644',
    content => epp("wildfly/wildfly.conf.${_startupfile}.epp", {
      'catalina_home' => $catalina_home,
      'user'          => $_user,
      'group'         => $_group,
      }),
    require => File['/etc/wildfly'],
  }

  file { "servicefile ${name}":
    ensure  => 'file',
    path    => "${_startupdir}/${name}${_startupext}",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => epp("wildfly/wildfly.${_startupfile}.epp", {
      'catalina_home' => $catalina_home,
      'user'          => $_user,
      'group'         => $_group,
      'instance'      => $name,
      }),
  }

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }
}

