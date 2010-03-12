class AddValuesToKayakRequest < ActiveRecord::Migration
  def self.up
    add_column :kayak_requests, :sid, :string
    add_column :kayak_requests, :search_id, :string
  end

  def self.down
    remove_column :kayak_requests, :search_id
    remove_column :kayak_requests, :sid
  end
end
