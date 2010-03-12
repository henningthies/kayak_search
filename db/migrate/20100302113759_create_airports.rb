class CreateAirports < ActiveRecord::Migration
  def self.up
    create_table :airports do |t|
      t.integer :airportid
      t.string :iata_code
      t.string :icao_code
      t.string :name
      t.string :city
      t.string :country
      t.float :lat
      t.float :lng
      t.integer :incommings
      t.integer :outgoings
      
      t.timestamps
    end
  end

  def self.down
    drop_table :airports
  end
end
