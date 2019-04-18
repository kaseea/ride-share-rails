class TripsController < ApplicationController
  def show
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      redirect_to root_path
    end
  end

  def new
    passenger = Passenger.find_by(id: params[:passenger_id])
    @trip = Trip.new(id: params[:id], date: DateTime.now, rating: null, cost: null)
  end

  def create
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
      redirect_to trip_path(trip.id)
    else
      @trip = trip
      render :edit, status: :bad_request
    end
  end

  def destroy
    trip = Trip.find_by(id: params[:id])

    if trip.nil?
      head :not_found
    else
      trip.destroy
      redirect_to root_path
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id)
  end
end
