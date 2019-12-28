class nextcloud::plugins (
  $install_plugin_keeweb           = $nextcloud::install_plugin_keeweb,
  $install_plugin_calendar         = $nextcloud::install_plugin_calendar,
  $install_plugin_collabora_online = $nextcloud::install_plugin_collabora_online,
  $install_plugin_contacts         = $nextcloud::install_plugin_contacts,
  $install_plugin_gallery          = $nextcloud::install_plugin_gallery,
  $plugin_collabora_ip             = $nextcloud::plugin_collabora_ip,
  $plugin_collabora_domain         = $nextcloud::plugin_collabora_domain,
) {


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
}
