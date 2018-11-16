class nextcloud::install (
  Stdlib::Absolutepath $install_dir_base  = $nextcloud::install_dir_base,
  Stdlib::Absolutepath $install_dir       = $nextcloud::install_dir,
  Stdlib::Absolutepath $data_directory    = $nextcloud::data_directory,
) {

  file { "$install_dir_base":
    ensure => directory,
  }
  file { "$install_dir":
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    require => File[$install_dir_base]
  }
  file { "$data_directory":
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    require => File[$install_dir_base]
  }

  archive { '/var/www/html/nextcloud-13.0.2.tar.bz2':
    ensure       => present,
    path         => '/tmp/nextcloud-13.0.2.tar.bz2',
    extract      => true,
    extract_path => $install_dir_base,
    source       => 'https://download.nextcloud.com/server/releases/nextcloud-13.0.2.tar.bz2',
    creates      => "$install_dir/index.php",
    cleanup      => true,
    user         => 'www-data',
    group        => 'www-data',
    require      => File[$install_dir],
  }
}
