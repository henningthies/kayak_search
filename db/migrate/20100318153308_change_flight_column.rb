class ChangeFlightColumn < ActiveRecord::Migration
  def self.up
    add_column :flights, :kayak_search_response, :longtext
    remove_column :flights, :kayak_request_id
  end

  def self.down
    add_column :flights, :kayak_request_id, :integer
    remove_column :flights, :kayak_search_response
  end
end
