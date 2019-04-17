require "test_helper"

describe DriversController do
  describe "index" do
    it "can get index" do
      get drivers_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should get show" do
      get driver_path(Driver.first.id)

      must_respond_with :success
    end

    it "will respond with 404 if the author is not found" do
      get driver_path(-1)

      must_redirect_to drivers_path
    end
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    # Your tests go here
  end

  describe "new" do
    # Your tests go here
  end

  describe "create" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
