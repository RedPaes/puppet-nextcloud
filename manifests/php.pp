class nextcloud::php (
  $php_version = $nextcloud::php_version,
) {

  $php_fpm_dir    = "/etc/php/${php_version}/fpm"
  $php_extensions = [
    "php${php_version}-mbstring",
    "php${php_version}-xmlrpc",
    "php${php_version}-soap",
    "php${php_version}-ldap",
    "php${php_version}-gd",
    "php${php_version}-xml",
    "php${php_version}-intl",
    "php${php_version}-json",
    "php${php_version}-mysql",
    "php${php_version}-cli",
    "php${php_version}-curl",
    "php${php_version}-zip"
  ]

  class { 'phpfpm':
    process_max  => 20,
    package_name => "php${php_version}-fpm",
    service_name => "php${php_version}-fpm",
    poold_purge  => true,
    config_dir   => $php_fpm_dir,
    pool_dir     => "${php_fpm_dir}/pool.d",
  }
  -> phpfpm::pool { 'nextcloud':
    listen       => "/run/php/php${php_version}-fpm.sock",
    listen_owner => 'www-data',
    service_name => "php${php_version}-fpm",
    pool_dir     => "${php_fpm_dir}/pool.d",
  }
  -> package { $php_extensions:
    ensure => present,
  }
}
