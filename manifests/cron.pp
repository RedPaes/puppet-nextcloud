class nextcloud::cron () {
  cron { 'nextcloud':
    ensure  => 'present',
    command => "php -f ${nextcloud::install::install_dir}/cron.php",
    minute  => ['*/5'],
    target  => 'www-data',
    user    => ' www-data',
  }
}
