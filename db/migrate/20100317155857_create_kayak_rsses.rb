class CreateKayakRsses < ActiveRecord::Migration
  def self.up
    create_table :kayak_rsses do |t|
      t.integer :flight_id
      t.column :xml, :longtext 

      t.timestamps
    end
  end

  def self.down
    drop_table :kayak_rsses
  end
end
