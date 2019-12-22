class nextcloud::plugin::contacts () {

  exec { "Install Contacts App":
    command  => 'php occ app:install richdocuments',
    user     => 'www-data',
    timeout  => 100,
    cwd      => "${nextcloud::install::install_dir}",
    creates  => "${nextcloud::install::install_dir}/apps/richdocuments/",
    provider => 'shell',
  }
}
