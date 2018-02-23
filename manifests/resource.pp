#
# Manages a Wildfly configuration resource: e.g `/subsystem=datasources/data-source=MyDS or /subsystem=datasources/jdbc-driver=postgresql`.
#   Virtually anything in your configuration XML file that can be manipulated using JBoss-CLI could be managed by this defined type.
#   This define is a wrapper for `wildfly_resource` that defaults to your local Wildfly installation.
#
# @param ensure Whether the resource should exist (`present`) or not (`absent`).
# @param recursive Whether it should manage the resource recursively or not.
# @param undefine_attributes Whether it should undefine attributes with undef value.
# @param content Sets the content/state of the target resource.
# @param operation_headers Sets [operation-headers](https://docs.jboss.org/author/display/WFLY9/Admin+Guide#AdminGuide-OperationHeaders) (e.g. `{ 'allow-resource-service-restart' => true, 'rollback-on-runtime-failure' => false, 'blocking-timeout' => 600}`) to be used when creating/destroying this resource.
# @param profile Sets the target profile to prefix resource name. Requires domain mode.
define wildfly::resource(
  Hash[Enum['username','password'], String]                                            $mgmt_user,
  Hash[Enum['management-http','management-https','ajp','http','https'], Integer[1024]] $port_properties,
  Hash[Enum['management','public'], Stdlib::Compat::Ip_address]                        $ip_properties,
  Enum[present, absent]                                                                $ensure = present,
  Boolean                                                                              $recursive = false,
  Boolean                                                                              $undefine_attributes = false,
  Hash                                                                                 $content = {},
  Hash                                                                                 $operation_headers = {},
  Optional[String]                                                                     $profile = undef,
) {

  $resource_info = split($title, ':')
  $resource = $resource_info[0]
  $catalina_home = $resource_info[1]

  $profile_path = wildfly::profile_path($profile)

  if $undefine_attributes {
    $attributes = $content
  } else {
    $attributes = delete_undef_values($content)
  }

  wildfly_resource { "${profile_path}${resource}${catalina_home}":
    ensure            => $ensure,
    path              => "${profile_path}${resource}",
    username          => $mgmt_user['username'],
    password          => $mgmt_user['password'],
    host              => $ip_properties['management'],
    port              => $port_properties['management-http'],
    recursive         => $recursive,
    state             => $attributes,
    operation_headers => $operation_headers,
  }
}
