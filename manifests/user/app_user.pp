#
# Manages an Application User (`application-users.properties`) for Wildfly.
#
# @param password The user password.
define wildfly::user::app_user(
  Stdlib::UnixPath $catalina_home,
  String           $password
) {

  tag(sha1($catalina_home))

  wildfly::user::user { "${title}:ApplicationRealm:${catalina_home}":
    password  => $password,
    file_name => 'application-users.properties',
  }
}
