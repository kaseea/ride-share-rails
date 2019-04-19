require "test_helper"

describe PassengersController do
  describe "index" do
    it "can get index" do
      get passengers_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should be OK to show an existing, valid passenger" do
      passenger = Passenger.create(
        name: "Firstname Lastname",
        phone_num: "123456ASVDSS",
      )

      valid_passenger_id = passenger.id

      get passenger_path(valid_passenger_id)

      must_respond_with :success
    end

    it "will redirect to passenger list if the passenger is not found" do
      invalid_passenger_id = -1

      get passenger_path(invalid_passenger_id)

      must_redirect_to passengers_path
    end
  end

  describe "create" do
    it "will save a new passenger and redirect if given valid inputs" do
      input_name = "FirstName LastName"
      input_phone_num = "12345ABCDE"

      test_input = {
        "passenger": {
          name: input_name,
          phone_num: input_phone_num,
        },
      }

      expect {
        post passengers_path, params: test_input
      }.must_change "Passenger.count", 1

      new_passenger = Passenger.find_by(name: input_name)
      expect(new_passenger).wont_be_nil
      expect(new_passenger.name).must_equal input_name
      expect(new_passenger.phone_num).must_equal input_phone_num

      must_respond_with :redirect
    end

    it "will return a 400 with an invalid passenger" do
      input_name = "" # invalid name
      input_phone_num = 123456
      test_input = {
        "passenger": {
          name: input_name,
          phone_num: input_phone_num,
        },
      }

      expect {
        post passengers_path, params: test_input
      }.wont_change "Passenger.count"

      must_respond_with :bad_request
    end
  end

  describe "update" do
    it "will update an existing passenger" do
      starter_input = {
        name: "Namey Name",
        phone_num: "123456",
      }

      passenger_to_update = Passenger.create(starter_input)

      input_name = "This is a new name"
      input_phone_num = "NUMB3RS"

      test_input = {
        "passenger": {
          name: input_name,
          phone_num: input_phone_num,
        },
      }

      expect {
        patch passenger_path(passenger_to_update.id), params: test_input
      }.wont_change "Passenger.count"

      must_respond_with :redirect
      passenger_to_update.reload
      expect(passenger_to_update.name).must_equal test_input[:passenger][:name]
      expect(passenger_to_update.phone_num).must_equal test_input[:passenger][:phone_num]
    end

    it "will return a bad_request (400) when asked to update with invalid data" do
      starter_input = {
        name: "Name",
        phone_num: "12345",
      }

      passenger_to_update = Passenger.create(starter_input)

      input_name = "" # invalid
      input_phone_num = "12345"

      test_input = {
        "passenger": {
          name: input_name,
          phone_num: input_phone_num,
        },
      }

      expect {
        patch passenger_path(passenger_to_update.id), params: test_input
      }.wont_change "Passenger.count"

      must_respond_with :bad_request
      passenger_to_update.reload
      expect(passenger_to_update.name).must_equal starter_input[:name]
      expect(passenger_to_update.phone_num).must_equal starter_input[:phone_num]
    end
  end

  describe "destroy" do
    it "can delete a passenger" do
      passenger = Passenger.create(name: "To Delete", phone_num: "12345")

      expect {
        delete passenger_path(passenger.id)
      }.must_change "Passenger.count", -1

      must_respond_with :redirect
      must_redirect_to passengers_path
    end

    it "404 if no passenger found" do
      invalid_passenger_id = -1

      expect {
        delete passenger_path(invalid_passenger_id)
      }.wont_change "Passenger.count"

      must_respond_with :not_found
    end
  end
end
