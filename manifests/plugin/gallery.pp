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
  exec { "Generate images":
    command  => 'php occ occ preview:generate-all',
    user     => 'www-data',
    timeout  => 1800, # 30min
    cwd      => "${nextcloud::install::install_dir}",
    creates  => "${nextcloud::install::install_dir}/apps/previewgenerator/",
    provider => 'shell',
  } ->
  cron { 'nextcloud-pregenerate-preview-images':
    ensure  => 'present',
    command => "php ${nextcloud::install::install_dir}/occ preview:pre-generate",
    minute  => ['45'],
    hour    => ['*/2'],
    target  => 'www-data',
    user    => 'www-data',
  }
}
