# define wildfly::install::package
# ===========================
define wildfly::install::package (
  String $package_ensure,
  String $package_options,
  String $package_name = $name,
) {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $package_name:
    ensure          => $package_ensure,
    install_options => $package_options,
  }
}
