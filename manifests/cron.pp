class nextcloud::cron () {
  cron { 'nextcloud-cronjob':
    ensure  => 'present',
    command => "php -f ${nextcloud::install::install_dir}/cron.php",
    minute  => ['*/5'],
    target  => 'www-data',
    user    => 'www-data',
  }

  cron { 'nextcloud-scan-files':
    ensure  => 'present',
    command => "php ${nextcloud::install::install_dir}/occ files:scan --all",
    minute  => ['15'],
    hour    => ['21'],
    target  => 'www-data',
    user    => 'www-data',
  }

}
