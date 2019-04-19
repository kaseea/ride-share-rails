class TripsController < ApplicationController
  def show
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      redirect_to root_path
    end
  end

  def create
    trip = Trip.new
    trip.date = DateTime.now
    trip.rating = nil
    trip.cost = 0
    trip.driver_id = Driver.all.sample.id
    trip.passenger_id = params[:passenger_id]
    is_successful = trip.save
    # please explain to me why trip path needs the id: trip.id and not just trip.id
    if is_successful
      redirect_to passenger_trip_path(id: trip.id)
    else
      #record not saved? we should look into this
      head :unprocessable_entity
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      redirect_to root_path
    end
  end

  def update
    trip = Trip.find_by(id: params[:id])

    if trip.nil?
      redirect_to root_path
    else
      is_successful = trip.update(trip_params)
    end

    if is_successful
      redirect_to passenger_trip_path(passenger_id: params[:passenger_id], id: params[:id])
    else
      @trip = trip
      render :edit, status: :bad_request
    end
  end

  def destroy
    trip = Trip.find_by(id: params[:id])

    passenger_id = trip.passenger.id
    driver_id = trip.driver.id

    if trip.nil?
      head :not_found
    else
      trip.destroy
      redirect_to passenger_path(passenger_id) # or to driver_path(driver_id) if from driver page????
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id)
  end
end
