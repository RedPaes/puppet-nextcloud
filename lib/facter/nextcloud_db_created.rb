Facter.add(:nextcloud_db_created) do
  setcode do
    if File.exist? '/root/.nextcloud_db_lock'
      true
    else
      false
    end
  end
end