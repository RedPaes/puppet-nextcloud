class nextcloud::plugin::gallery () {

  exec { "Install Gallery App":
    command  => 'php occ app:install gallery',
    user     => 'www-data',
    timeout  => 100,
    cwd      => "${nextcloud::install::install_dir}",
    creates  => "${nextcloud::install::install_dir}/apps/gallery/",
    provider => 'shell',
  } ->
  exec { "Install Preview Generator App":
    command  => 'php occ app:install previewgenerator',
    user     => 'www-data',
    timeout  => 100,
    cwd      => "${nextcloud::install::install_dir}",
    creates  => "${nextcloud::install::install_dir}/apps/previewgenerator/",
    provider => 'shell',
  } ->
  cron { 'nextcloud-generate-preview-images':
    ensure  => 'present',
    command => "sudo -u www-data php nextcloud/occ preview:generate-all",
    minute  => ['45'],
    hour    => ['*/2'],
    target  => 'www-data',
    user    => 'www-data',
  }
}
