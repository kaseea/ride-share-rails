class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all
  end

  def show
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      redirect_to passengers_path
    end
  end

  def new
    @passenger = Passenger.new
  end

  def create
    passenger = Passenger.new(passenger_params)

    is_successful = passenger.save

    if is_successful
      redirect_to passenger_path(passenger.id)
    else
      render :new, status: :bad_request
    end
  end

  def edit
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      redirect_to passengers_path
    end
  end

  def update
    passenger = Passenger.find_by(id: params[:id])

    if passenger.nil?
      redirect_to passengers_path
    else
      is_successful = passenger.update(passenger_params)
    end

    if is_successful
      redirect_to passenger_path(passenger.id)
    else
      @passenger = passenger
      render :edit, status: :bad_request
    end
  end

  def destroy
    passenger = Passenger.find_by(id: params[:id])

    if passenger.nil?
      head :not_found
    else
      passenger.trips.each do |trip|
        trip.destroy
      end
      passenger.destroy
      redirect_to passengers_path
    end
  end

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
