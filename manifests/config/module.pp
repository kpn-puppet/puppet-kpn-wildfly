#
# Manages a Wildfly module (`$WILDFLY_HOME/modules`).
#
# @param source Sets the source for this module, either a local file `file://`, a remote one `http://` or `puppet://`.
# @param template Sets the EPP template to module.xml file. Default to 'wildfly/module.xml'.
# @param dependencies Sets the dependencies for this module e.g. `javax.transaction`.
# @param system Whether this is a system (`system/layers/base`) module or not.
# @param custom_file Sets a file source for module.xml. If set, template is ignored.
define wildfly::config::module(
  Variant[Pattern[/^\./], Pattern[/^file:\/\//], Pattern[/^puppet:\/\//], Stdlib::Httpsurl, Stdlib::Httpurl] $source,
  String                                                                                                     $checksum,
  Enum['none','sha1','sha256','sha512']                                                                      $checksum_type = 'sha256',
  String                                                                                                     $template = 'wildfly/module.xml', # lint:ignore:140chars
  Boolean                                                                                                    $allow_insecure = true,
  Boolean                                                                                                    $system = true,
  Array                                                                                                      $dependencies = [],
  Optional[String]                                                                                           $user = undef,
  Optional[String]                                                                                           $group = undef,
  Optional[String]                                                                                           $custom_file = undef,
  Optional[Enum['none','http','https']]                                                                      $proxy_type = undef,
  Optional[Variant[Stdlib::Httpurl, Stdlib::Httpsurl]]                                                       $proxy_server = undef,
) {

  include ::wildfly
  $module_info = split($title, ':')
  $module = $module_info[0]
  $catalina_home = $module_info[1]
  $namespace_path = regsubst($module, '[.]', '/', 'G')
  $_catalina_home = pick($catalina_home, $::wildfly::catalina_home)
  tag(sha1($_catalina_home))
  $_user = pick($user, $::wildfly::user)
  $_group = pick($group, $::wildfly::group)

  if $system {
    $module_dir = 'system/layers/base'
  }

  $dir_path = "${_catalina_home}/modules/${module_dir}/${namespace_path}/main"

  exec { "Create Parent Directories: ${module} for ${_catalina_home}":
    path    => ['/bin','/usr/bin', '/sbin'],
    command => "mkdir -p ${dir_path}",
    unless  => "test -d ${dir_path}",
    user    => $_user,
    before  => [File[$dir_path]],
  }

  file { $dir_path:
    ensure => directory,
    owner  => $_user,
    group  => $_group,
  }

  if $source == '.' {
    $file_name = '.'
  } else {
    $file_name = basename($source)
  }

  case $source {
    '.': {
    }
    /^(file:|puppet:)/: {
      file { "${dir_path}/${file_name}":
        ensure => file,
        owner  => $_user,
        group  => $_group,
        mode   => '0655',
        source => $source,
      }
    }
    default : {
      archive { "${dir_path}/${file_name}":
        ensure         => present,
        source         => $source,
        allow_insecure => $allow_insecure,
        checksum       => $checksum,
        checksum_type  => 'sha256',
        extract        => false,
        proxy_server   => $proxy_server,
        proxy_type     => $proxy_type,
        require        => File[$dir_path],
      }
      file { "${dir_path}/${file_name}":
        ensure    => file,
        owner     => $_user,
        group     => $_group,
        mode      => '0640',
        subscribe => Archive["${dir_path}/${file_name}"],
      }
    }
  }

  if $custom_file {
    file { "${dir_path}/module.xml":
      ensure  => file,
      owner   => $_user,
      group   => $_group,
      content => file($custom_file),
    }
  } else {
    $params = {
      'file_name'    => $file_name,
      'dependencies' => $dependencies,
      'name'         => $module,
    }

    file { "${dir_path}/module.xml":
      ensure  => file,
      owner   => $_user,
      group   => $_group,
      content => epp($template, $params),
    }
  }
}
