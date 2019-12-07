class nextcloud::plugin::keepass () {

  file { "${nextcloud::install::install_dir}/resources/config/mimetypealiases.json ":
    ensure    => present,
    owner     => 'www-data',
    group     => 'www-data',
    mode      => '0640',
    show_diff => false,
    content   => template('nextcloud/mimetypealiases.json'),
  }

  exec { "Install Keeweb App":
    command  => 'php occ app:install keeweb',
    user     => 'www-data',
    timeout  => 100,
    cwd      => "${nextcloud::install::install_dir}",
    creates  => "${nextcloud::install::install_dir}/apps/keeweb/",
    provider => 'shell',
  } ->
  exec { "Update Mimetypes":
    command  => 'php occ maintenance:mimetype:update-js',
    user     => 'www-data',
    timeout  => 100,
    cwd      => "${nextcloud::install::install_dir}",
    provider => 'shell',
  }
}
