class CreateFlights < ActiveRecord::Migration
  def self.up
    create_table :flights do |t|
      t.string :origin
      t.string :destination
      t.date :depart_date
      t.integer :arrival_airport_id
      t.integer :departure_airport_id
      t.integet :kayak_request_id
      t.timestamps
    end
  end

  def self.down
    drop_table :flights
  end
end
