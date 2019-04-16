class RemoveDriverIdAndPassengerIdFromTrips < ActiveRecord::Migration[5.2]
  def change
    remove_column(:trips, :passenger_id)
    remove_column(:trips, :driver_id)
  end
end
