class nextcloud::database (
  $db_type          = $nextcloud::db_type,
  $db_name          = $nextcloud::db_name,
  $db_user          = $nextcloud::db_user,
  $db_password      = $nextcloud::db_password,
  $db_host          = $nextcloud::db_host,
  $db_root_password = $nextcloud::db_root_password,
  $lock_file_path   = '/root/.nextcloud_db_lock'
) {

  $override_options = {
    'mysqld' => {
      'innodb_file_per_table' => '1',
      'innodb_large_prefix'   => 'true',
      'innodb_file_format'    => 'Barracuda',
      'character-set-server'  => 'utf8mb4',
      'collation-server'      => 'utf8mb4_unicode_ci',
    },
    'client' => {
      'default-character-set' => 'utf8mb4',
    },
    'mysql'  => {
      'default-character-set' => 'utf8mb4',
    },
  }

  class { '::mysql::server':
    package_name     => 'mariadb-server',
    service_name     => 'mariadb',
    root_password    => $db_root_password,
    override_options => $override_options,
    restart          => false,
  }

  if ! $facts['nextcloud_db_created'] {
    warning('Create database since it does not exits')

    mysql::db { $db_name:
      user     => $db_user,
      password => $db_password,
      host     => $db_host,
      grant    => ['ALL'],
    }
    file { $lock_file_path:
      ensure  => 'present',
      replace => 'no', # this is the important property
      content => "DB Lock for Nextcloud",
      mode    => '0644',
    }

  }
}