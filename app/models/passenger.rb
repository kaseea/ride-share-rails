class Passenger < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :phone_num, presence: true

  def total_charged
    return 0 if trips.length == 0
    sum = 0
    trips.each do |trip|
      sum += trip.cost
    end
    return sum / 100.0
  end
end
