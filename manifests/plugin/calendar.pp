class nextcloud::plugin::calendar () {

  exec { "Install Calendar App":
    command  => 'php occ app:install calendar',
    user     => 'www-data',
    timeout  => 100,
    cwd      => "${nextcloud::install::install_dir}",
    creates  => "${nextcloud::install::install_dir}/apps/calendar/",
    provider => 'shell',
  }
}
