# Generic Wildfly user management.
#
define wildfly::user::user(
  String $password,
  String $file_name,
) {

  $user_info = split($title, ':')
  $username = $user_info[0]
  $realm = $user_info[1]
  $catalina_home = $user_info[2]

  tag(sha1($catalina_home))

  $password_hash = inline_template('<%= require \'digest/md5\'; Digest::MD5.hexdigest("#{@username}:#{@realm}:#{@password}") %>')

  file_line { "${catalina_home}:${username}:${realm}":
    path  => "${catalina_home}/standalone/configuration/${file_name}",
    line  => "${username}=${password_hash}",
    match => "^${username}=.*\$",
  }
}
