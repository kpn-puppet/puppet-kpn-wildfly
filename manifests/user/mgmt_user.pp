#
# Manages a Management User (`mgmt-users.properties`) for Wildfly.
#
# @param password The user password.
define wildfly::user::mgmt_user(
  String $password,
) {

  $user_info = split($title, ':')
  $username = $user_info[0]
  $catalina_home = $user_info[1]

  tag(sha1($catalina_home))

  wildfly::user::user { "${username}:ManagementRealm:${catalina_home}":
    password  => $password,
    file_name => 'mgmt-users.properties',
  }
}
