class nextcloud::redis (
  $redis_password = $nextcloud::redis_password,
) {

  class { '::redis':
    bind       => '127.0.0.1',
    masterauth => $redis_password,
  }

}