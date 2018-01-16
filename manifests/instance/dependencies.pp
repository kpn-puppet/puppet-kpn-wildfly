# define wildfly::instance::dependencies
# ===========================
define wildfly::instance::dependencies (
  Stdlib::Unixpath $catalina_home,
) {
  $home_sha = sha1($catalina_home)

  Wildfly::Install                      <| tag == $home_sha |>
  -> Wildfly::Instance                  <| tag == $home_sha |>

    Wildfly::Install                    <| tag == $home_sha |>
  -> Wildfly::Config::Connector         <| tag == $home_sha |>
  ~> Wildfly::Service                   <| tag == $home_sha |>

    Wildfly::Install                    <| tag == $home_sha |>
  -> Wildfly::User::User                <| tag == $home_sha |>
  ~> Wildfly::Service                   <| tag == $home_sha |>

  Wildfly::Service                      <| tag == $home_sha |>
  -> Wildfly::Datasources::Driver       <| tag == $home_sha |>
  -> WildFly::Datasources::Datasource   <| tag == $home_sha |>

  Wildfly::Install                      <| tag == $home_sha |>
  -> Wildfly::Config::Module            <| tag == $home_sha |>
  ~> Wildfly::Service                   <| tag == $home_sha |>

}
