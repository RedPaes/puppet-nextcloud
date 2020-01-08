class nextcloud::php (
  $php_version  = $nextcloud::php_version,
  $hostname     = $facts['networking']['fqdn'],
  $path_vars    = $facts['path'],
  $tmp_dir      = '/tmp',
  $max_upload   = '2G',
  $memory_limit = '512M'
) {

  $php_fpm_dir = "/etc/php/${php_version}/fpm"
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
    "php${php_version}-zip",
    "php${php_version}-imagick",
    "php${php_version}-apcu",
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
    listen          => "/run/php/php${php_version}-fpm.sock",
    listen_owner    => 'www-data',
    service_name    => "php${php_version}-fpm",
    pool_dir        => "${php_fpm_dir}/pool.d",
    env             => {
      'HOSTNAME' => $hostname,
      'PATH'     => $path,
      'TMP'      => $tmp_dir,
      'TMPDIR'   => $tmp_dir,
      'TEMP'     => $tmp_dir,

    },
    php_admin_value => {
      'max_execution_time'  => '300',
      'memory_limit'        => $memory_limit,
      'upload_max_filesize' => $max_upload,
      'post_max_size'       => $max_upload,
    },
  }
  -> package { $php_extensions:
    ensure => present,
  }
}
