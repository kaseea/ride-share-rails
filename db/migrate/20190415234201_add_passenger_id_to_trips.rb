class AddPassengerIdToTrips < ActiveRecord::Migration[5.2]
  def change
    add_column(:trips, :passenger_id, :integer)
  end
end
