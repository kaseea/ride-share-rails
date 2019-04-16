class Driver < ApplicationRecord
  has_many :trips

  def average_rating
    return "no trips" if trips.length == 0
    sum = 0
    trips.each do |x|
      sum += x.rating.to_f
    end
    return (sum / trips.length).round(2)
  end

  def total_cost
    return "no trips" if trips.length == 0
    sum = 0
    trips.each do |trip|
      sum += (trip.cost - 165) * 0.8
    end
    return (sum / 100.0).round(2)
  end
end
