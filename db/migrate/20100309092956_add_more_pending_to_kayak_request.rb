class AddMorePendingToKayakRequest < ActiveRecord::Migration
  def self.up
    add_column :kayak_requests, :more_pending, :string
  end

  def self.down
    remove_column :kayak_requests, :more_pending
  end
end
