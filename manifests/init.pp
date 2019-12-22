# Class: nextcloud
# ===========================
#
# Class to install nextcloud server.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'nextcloud':
#      ssl_key_file  => '/etc/nginx/ssl/server.key',
#      ssl_cert_file => '/etc/nginx/ssl/server.crt',
#    }
#
# Authors
# -------
#
# Othalla <othalla.lf@gmail.com>
#
#
class nextcloud (
  String $version                                     = 'latest',
  String $archive                                     = "$version.tar.bz2",
  Stdlib::Httpurl $archive_url                        = "https://download.nextcloud.com/server/releases/$archive",
  Stdlib::Absolutepath $install_dir_base              = '/var/www/nextcloud',
  Stdlib::Absolutepath $data_directory                = "$install_dir_base/data",
  Boolean $db_manage                                  = true,
  String $db_type                                     = 'mysql',
  String $db_name                                     = 'nextcloud',
  String $db_user                                     = 'nextcloud',
  String $db_password                                 = 'nextcloud',
  String $db_host                                     = 'localhost',
  Variant[Undef, String] $db_table_prefix             = undef,
  Variant[Undef, String] $admin_user                  = undef,
  Variant[Undef, String] $admin_password              = undef,
  String $db_root_password                            = 'defaultpassword',
  Array[String] $server_names                         = ['localhost'],
  Integer $http_port                                  = 80,
  Integer $https_port                                 = 443,
  Boolean $ssl                                        = false,
  Variant[Undef, Stdlib::Absolutepath] $ssl_key_file  = undef,
  Variant[Undef, Stdlib::Absolutepath] $ssl_cert_file = undef,
  String $php_version                                 = '7.2',
  Integer $worker_processes                           = 2,
  Boolean $install_plugin_keeweb                      = true,
  Boolean $install_plugin_calendar                    = true,
  Boolean $install_plugin_contacts                    = true,
  Boolean $install_plugin_gallery                     = true,
  Boolean $install_plugin_collabora_online            = true,
  String  $plugin_collabora_domain                    = 'office.meyer-cloud.ch',
  String $plugin_collabora_ip                         = '172.16.0.7',
  Boolean $enable_cron                                = true,

) {

  if $ssl and !($ssl_cert_file and $ssl_key_file) {
    fail('You must provide certificate file and key file for SSL config.')
  }

  $install_dir = "$install_dir_base/nextcloud"

  contain nextcloud::php
  contain nextcloud::install
  contain nextcloud::webserver
  include nextcloud::config


  Class['nextcloud::php']
  -> Class['nextcloud::install']
  -> Class['nextcloud::webserver']
  -> Class['nextcloud::config']


  if $install_plugin_keeweb {
    contain nextcloud::plugin::keepass

  }

  if $install_plugin_contacts {
    contain nextcloud::plugin::contacts

  }

  if $install_plugin_calendar {
    contain nextcloud::plugin::calendar
  }

  if $install_plugin_gallery {
    contain nextcloud::plugin::gallery
  }
  if $install_plugin_collabora_online {
    contain nextcloud::plugin::gallery
    host { $plugin_collabora_domain:
      ip => $plugin_collabora_ip,
    }

  }


  if $enable_cron {
    contain nextcloud::cron
  }

  if $db_manage {
    contain nextcloud::database

    Class['nextcloud::database']
    -> Class['nextcloud::php']
  }
}
