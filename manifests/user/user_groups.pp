#
# Manages groups for a Management User (`mgmt-groups.properties`).
#
# @param groups List of groups to associate with this user.
define wildfly::user::user_groups(
  Stdlib::UnixPath $catalina_home,
  String           $groups
) {

  tag(sha1($catalina_home))

  file_line { "${catalina_home}:${title}:${groups}":
    path  => "${catalina_home}/standalone/configuration/mgmt-groups.properties",
    line  => "${title}=${groups}",
    match => "^${title}=.*\$",
  }
}
