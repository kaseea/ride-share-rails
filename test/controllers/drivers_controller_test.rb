require "test_helper"

describe DriversController do
  describe "index" do
    it "can get index" do
      get drivers_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should be OK to show an existing, valid driver" do
      driver = Driver.create(
        name: "Firstname Lastname",
        vin: "123456ASVDSS",
      )

      valid_driver_id = driver.id

      get driver_path(valid_driver_id)

      must_respond_with :success
    end

    it "will redirect to driver list if the driver is not found" do
      invalid_driver_id = -1

      get driver_path(invalid_driver_id)

      must_redirect_to drivers_path
    end
  end

  describe "create" do
    it "will save a new driver and redirect if given valid inputs" do
      input_name = "FirstName LastName"
      input_vin = "12345ABCDE"

      test_input = {
        "driver": {
          name: input_name,
          vin: input_vin,
        },
      }

      expect {
        post drivers_path, params: test_input
      }.must_change "Driver.count", 1

      new_driver = Driver.find_by(name: input_name)
      expect(new_driver).wont_be_nil
      expect(new_driver.name).must_equal input_name
      expect(new_driver.vin).must_equal input_vin

      must_respond_with :redirect
    end

    it "will return a 400 with an invalid driver" do
      input_name = "" # invalid name
      input_vin = 123456
      test_input = {
        "driver": {
          name: input_name,
          vin: input_vin,
        },
      }

      expect {
        post drivers_path, params: test_input
      }.wont_change "Driver.count"

      must_respond_with :bad_request
    end
  end

  describe "update" do
    it "will update an existing driver" do
      starter_input = {
        name: "Namey Name",
        vin: "123456",
      }

      driver_to_update = Driver.create(starter_input)

      input_name = "This is a new name"
      input_vin = "NUMB3RS"

      test_input = {
        "driver": {
          name: input_name,
          vin: input_vin,
        },
      }

      expect {
        patch driver_path(driver_to_update.id), params: test_input
      }.wont_change "Driver.count"

      must_respond_with :redirect
      driver_to_update.reload
      expect(driver_to_update.name).must_equal test_input[:driver][:name]
      expect(driver_to_update.vin).must_equal test_input[:driver][:vin]
    end

    it "will return a bad_request (400) when asked to update with invalid data" do
      starter_input = {
        name: "Name",
        vin: "12345",
      }

      driver_to_update = Driver.create(starter_input)

      input_name = "" # invalid
      input_vin = "12345"

      test_input = {
        "driver": {
          name: input_name,
          vin: input_vin,
        },
      }

      expect {
        patch driver_path(driver_to_update.id), params: test_input
      }.wont_change "Driver.count"

      must_respond_with :bad_request
      driver_to_update.reload
      expect(driver_to_update.name).must_equal starter_input[:name]
      expect(driver_to_update.vin).must_equal starter_input[:vin]
    end
  end

  describe "destroy" do
    it "can delete a driver" do
      driver = Driver.create(name: "To Delete", vin: "12345")

      expect {
        delete driver_path(driver.id)
      }.must_change "Driver.count", -1

      must_respond_with :redirect
      must_redirect_to drivers_path
    end

    it "deletes trips associated with driver (but not passenger)" do
      driver = Driver.create(name: "To Delete", vin: "12345")
      passenger = Passenger.create(name: "Passenger", phone_num: "12345566")
      trip = Trip.create(driver: driver, passenger: passenger, date: DateTime.now, cost: 123, rating: 4)

      num_of_passengers = Passenger.all.length

      expect {
        delete driver_path(driver.id)
      }.must_change "Trip.count", -1

      expect(Passenger.all.length).must_equal num_of_passengers
    end

    it "404 if no driver found" do
      invalid_passenger_id = -1

      expect {
        delete driver_path(invalid_passenger_id)
      }.wont_change "Driver.count"

      must_respond_with :not_found
    end
  end
end
