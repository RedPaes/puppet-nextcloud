class nextcloud::redis (
  $redis_password = $nextcloud::redis_password,
) {

  class { '::redis':
    bind       => '127.0.0.1',
    masterauth => $redis_password,
  }

  package { 'memcached':
    ensure => installed,
    name   => 'memcached',
  }
  package { 'php-memcached':
    ensure => installed,
    name   => 'php-memcached',
  }
  package { 'php-redis':
    ensure => installed,
    name   => 'php-redis',
  }
  exec {"allow webserver access to socket":
    unless  => '/bin/grep -q "redis\\S*www-data" /etc/group',
    command => "/usr/sbin/usermod -a -G redis www-data",
    require => Package['redis-server'],
  }

  $redis_specific_nc_config = @(EOT)

{
    "system": {
        "memcache.local": "\\OC\\Memcache\\APCu",
        "memcache.distributed": "\\OC\\Memcache\\Redis",
        "memcache.locking" : "\OC\Memcache\Redis",
        "redis": {
            "host": ["127.0.0.1"],
            "port": 0,
            "dbindex": 0,
            "password": "secret"
            }
    }
}
    | EOT

  $config_dir = "$nextcloud::install_dir/.puppet_conf/"
  $full_config_file_path = "$config_dir/redis_settings.json"

  file { $config_dir:
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0750',
  } ->
  file { $full_config_file_path:
    ensure    => present,
    owner     => 'www-data',
    group     => 'www-data',
    mode      => '0640',
    show_diff => false,
    content   => $redis_specific_nc_config,
    require   => File[$config_dir],

  }
  exec { "Nextcloud config Redis Password":
    command  => "php occ config:import $full_config_file_path",
    user     => 'www-data',
    timeout  => 100,
    cwd      => "$nextcloud::install::install_dir",
    provider => 'shell',
    require  => File[$full_config_file_path],
  }
}