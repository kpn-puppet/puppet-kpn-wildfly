# define wildfly::install::source
# ===========================
define wildfly::install::source (
  Stdlib::Unixpath                                     $catalina_home,
  Boolean                                              $manage_base,
  Variant[Stdlib::Httpurl, Stdlib::Httpsurl]           $source,
  String                                               $checksum,
  Enum['none','sha1','sha256','sha512']                $checksum_type,
  Boolean                                              $source_strip_first_dir,
  String                                               $user,
  String                                               $group,
  Boolean                                              $allow_insecure,
  Optional[Enum['none','http','https']]                $proxy_type,
  Optional[Variant[Stdlib::Httpurl, Stdlib::Httpsurl]] $proxy_server,
) {
  tag(sha1($catalina_home))

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $source_strip_first_dir {
    $_strip = 1
  } else {
    $_strip = 0
  }

  $filename = regsubst($source, '.*/(.*)', '\1')

  if $manage_base {
    file { $catalina_home:
      ensure => directory,
      owner  => $user,
      group  => $group,
    }
  }

  archive { "${name}-${catalina_home}/${filename}":
    path           => "${catalina_home}/${filename}",
    source         => $source,
    checksum       => $checksum,
    checksum_type  => $checksum_type,
    extract        => true,
    extract_path   => $catalina_home,
    creates        => "${catalina_home}/README.txt",
    extract_flags  => "--strip ${_strip} -xf",
    cleanup        => true,
    allow_insecure => $allow_insecure,
    user           => $user,
    group          => $group,
    proxy_server   => $proxy_server,
    proxy_type     => $proxy_type,
  }
}
