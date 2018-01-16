#
# Manages roles for an Application User (`application-roles.properties`).
#
# @param groups List of roles to associate with this user.
define wildfly::user::user_roles(
  Stdlib::UnixPath $catalina_home,
  String           $roles
) {

  tag(sha1($catalina_home))

  file_line { "${catalina_home}:${title}:${roles}":
    path  => "${catalina_home}/standalone/configuration/application-roles.properties",
    line  => "${title}=${roles}",
    match => "^${title}=.*\$",
  }
}
