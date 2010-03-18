class AddReturnDateToFlight < ActiveRecord::Migration
  def self.up
    add_column :flights, :return_date, :date
  end

  def self.down
    remove_column :flights, :return_date
  end
end
