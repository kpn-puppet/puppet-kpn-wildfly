# define wildfly::install
# ===========================
define wildfly::install (
  Stdlib::Unixpath                                     $catalina_home          = $name,
  Boolean                                              $install_from_source    = true,

  # source options
  Optional[Variant[Stdlib::Httpurl, Stdlib::Httpsurl]] $source                 = undef,
  Optional[String]                                     $checksum               = undef,
  Optional[Enum['none','sha1','sha256','sha512']]      $checksum_type          = 'sha256',
  Boolean                                              $source_strip_first_dir = true,
  Optional[Enum['none','http','https']]                $proxy_type             = undef,
  Optional[Variant[Stdlib::Httpurl, Stdlib::Httpsurl]] $proxy_server           = undef,
  Boolean                                              $allow_insecure         = false,
  Optional[String]                                     $user                   = undef,
  Optional[String]                                     $group                  = undef,
  Optional[Boolean]                                    $manage_user            = undef,
  Optional[Boolean]                                    $manage_group           = undef,
  Optional[Boolean]                                    $manage_base            = undef,

  # package options
  String                                               $package_ensure         = 'present',
  Optional[String]                                     $package_name           = undef,
  Optional[String]                                     $package_options        = undef,
) {
  include ::wildfly
  $_user = pick($user, $::wildfly::user)
  $_group = pick($group, $::wildfly::group)
  $_manage_user = pick($manage_user, $::wildfly::manage_user)
  $_manage_group = pick($manage_group, $::wildfly::manage_group)
  $_manage_base = pick($manage_base, $::wildfly::manage_base)
  tag(sha1($catalina_home))

  if $install_from_source {
    if $_manage_user {
      ensure_resource('user', $_user, {
        ensure => present,
        gid    => $_group,
        })
    }
    if $_manage_group {
      ensure_resource('group', $_group, {
        ensure => present,
        })
    }
    wildfly::install::source { $name:
      catalina_home          => $catalina_home,
      manage_base            => $_manage_base,
      source                 => $source,
      checksum               => $checksum,
      checksum_type          => $checksum_type,
      source_strip_first_dir => $source_strip_first_dir,
      proxy_type             => $proxy_type,
      proxy_server           => $proxy_server,
      allow_insecure         => $allow_insecure,
      user                   => $_user,
      group                  => $_group,
    }
  } else {
    wildfly::install::package { $package_name:
      package_ensure  => $package_ensure,
      package_options => $package_options,
    }
  }
}
