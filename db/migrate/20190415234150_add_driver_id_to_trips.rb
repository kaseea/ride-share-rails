class AddDriverIdToTrips < ActiveRecord::Migration[5.2]
  def change
    add_column(:trips, :driver_id, :integer)
  end
end
