class nextcloud::install (
  String $archive                         = $nextcloud::archive,
  Stdlib::Httpurl $archive_url            = $nextcloud::archive_url,
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

  archive { "$archive":
    ensure       => present,
    path         => "/tmp/$archive",
    extract      => true,
    extract_path => $install_dir_base,
    source       => $archive_url,
    creates      => "$install_dir/index.php",
    cleanup      => true,
    user         => 'www-data',
    group        => 'www-data',
    require      => File[$install_dir],
  }
}
