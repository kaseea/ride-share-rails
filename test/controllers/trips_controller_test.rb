require "test_helper"

describe TripsController do
  describe "show" do

    # Arrange
    it "should get show" do
      driver = Driver.create(name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9")
      passenger = Passenger.create(name: "Nina Hintz Sr.", phone_num: "560.815.3059")
      #Does .create call the method in trips_controller or a ruby method somewhere else? wondering cause I thought I was hardcoding some of the default values
      trip = Trip.create(driver_id: driver.id, passenger_id: passenger.id, date: DateTime.now, rating: 4, cost: 1234)

      get passenger_trip_path(passenger_id: passenger.id, id: trip.id)

      must_respond_with :success
    end
    # Your tests go here
    it "will respond with 404 if the trip is not found" do
      get passenger_trip_path(passenger_id: 1, id: -1)

      must_redirect_to root_path
    end
  end

  describe "edit" do
    # Your tests go here
    it "should allow an edit" do
      driver = Driver.create(name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9")
      passenger = Passenger.create(name: "Nina Hintz Sr.", phone_num: "560.815.3059")
      trip = Trip.create(driver_id: driver.id, passenger_id: passenger.id, date: DateTime.now, rating: 4, cost: 1234)

      get edit_passenger_trip_path(passenger_id: passenger.id, id: trip.id)

      must_respond_with :success
    end
    it "should respond with a redirct to homepage if the trip doesn't exist" do
      get edit_passenger_trip_path(passenger_id: 1, id: -1)

      must_redirect_to root_path
    end
  end

  describe "update" do
    it "should update trips" do
      driver = Driver.create(name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9")
      passenger = Passenger.create(name: "Nina Hintz Sr.", phone_num: "560.815.3059")
      trip = Trip.create(driver_id: driver.id, passenger_id: passenger.id, date: DateTime.now, rating: 4, cost: 1234)

      trip_p = {
        trip: {
          id: trip.id,
          driver_id: trip.driver_id,
          passenger_id: trip.passenger_id,
          date: trip.date,
          rating: 4,
          cost: 69,
        },
      }
      patch passenger_trip_path(passenger_id: passenger.id, id: trip.id), params: trip_p

      must_respond_with :redirect
      expect(Trip.find_by(cost: 69).cost).must_equal 69
    end

    it "should respond with a bad request if the driver id empty" do
      driver = Driver.create(name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9")
      passenger = Passenger.create(name: "Nina Hintz Sr.", phone_num: "560.815.3059")
      trip = Trip.create(driver_id: driver.id, passenger_id: passenger.id, date: DateTime.now, rating: 4, cost: 1234)

      trip_p = {
        trip: {
          driver_id: "",
        },
      }
      patch passenger_trip_path(passenger_id: passenger.id, id: trip.id), params: trip_p

      must_respond_with :bad_request
    end

    it "should redirect to main page if trip not found" do
      driver = Driver.create(name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9")
      passenger = Passenger.create(name: "Nina Hintz Sr.", phone_num: "560.815.3059")
      trip = Trip.create(driver_id: driver.id, passenger_id: passenger.id, date: DateTime.now, rating: 4, cost: 1234)

      # AbstractController::DoubleRenderError: Render and/or redirect were called multiple times in this action. Please note that you may only call render OR redirect, and at most once per action. Also note that neither redirect nor render terminate execution of the action, so if you want to exit an action after redirecting, you need to do something like "redirect_to(...) and return".

      trip_p = {
        trip: {},
      }

      patch passenger_trip_path(passenger_id: passenger.id, id: -1), params: trip_p

      must_redirect_to root_path
    end
  end

  describe "create" do
    # Your tests go here
    it "should create new trip" do
      driver = Driver.create(name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9")

      passenger = Passenger.create(name: "Nina Hintz Sr.", phone_num: "560.815.3059")

      expect {
        post passenger_trips_path(passenger_id: passenger.id)
      }.must_change "Trip.count", 1

      must_respond_with :redirect
    end

    it "should respond with a 422 if it doesn't crete" do
      expect {
        post passenger_trips_path(passenger_id: -1)
      }.wont_change "Trip.count"

      #want to say it's bad because its bad input not
      must_respond_with :unprocessable_entity
    end
  end

  describe "destroy" do
    # Your tests go here
    it "can delete a trip" do
      driver = Driver.create(name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9")
      passenger = Passenger.create(name: "Nina Hintz Sr.", phone_num: "560.815.3059")
      trip = Trip.create(driver_id: driver.id, passenger_id: passenger.id, date: DateTime.now, rating: 4, cost: 1234)

      expect {

        # Act
        delete passenger_trip_path(passenger_id: passenger.id, id: trip.id)

        # Assert
      }.must_change "Trip.count", -1

      must_respond_with :redirect
      must_redirect_to passenger_path(passenger.id)
    end

    it "can give a 404 if trip to be deleted isn't found" do
      passenger = Passenger.create(name: "Nina Hintz Sr.", phone_num: "560.815.3059")

      expect(passenger).must_be_kind_of Passenger

      delete passenger_trip_path(passenger_id: passenger.id, id: -1)

      must_respond_with :not_found
    end
  end
end
