require 'spec_helper'

describe Reservation do
  subject { 
    Reservation.new do |r|
      r.location_name = 'Test'
      r.latitude = '123'
      r.longitude = '456'
      r.party_size = 3
      r.city  = 'Boston'
      r.user  = user_with_credit_card
      r.state = "MA"
      r.reserve_at = DateTime.parse('2010-12-12 3:20')
      r.address = "some address"
      r.zip = "12345"
      r.yelp_id = "someid"
    end
  }

  describe "#taskified_title" do
    it "returns a proper title" do
      subject.taskified_title.should == "Make a reservation to #{subject.location_name} for Sunday, 12 December at 3:20am"
    end
  end

  describe "#taskified_description" do
    it "returns a proper description" do
      expected_description = <<-TEXT
      I am looking for a TaskRabbit to go to #{subject.location_name} to make a reservation for Sunday, 12 December at 3:20am.
      The party is of 3.
      Please call me when you arrive at the restaurant to tell me when I would have to come.

      Thank you.

      Task Posted on saveaspotfor.me
      TEXT

      subject.taskified_description.should == expected_description.gsub(/ +/, ' ').strip
    end
  end

  describe "#save" do
    it "requires the location_name and the reservation datetime" do
      subject.location_name = ""
      subject.reserve_at    = nil

      subject.should_not be_valid

      subject.errors[:location_name].should == ["can't be blank"]
      subject.errors[:reserve_at].should    == ["can't be blank"]
    end

    it "creates a valid task on taskrabbit" do
      title, description = mock, mock
      Reservation.any_instance.stub(taskified_title: title)
      Reservation.any_instance.stub(taskified_description: description)
      Taskrabbit::Task.should_receive(:new).with(
      {
        name: title,
        description: description,
        named_price: Reservation::FIXED_PRICE,
        other_locations_attributes: [
          {
            name: subject.location_name,
            address: "some address",
            city: "Boston",
            state: "MA",
            zip: "12345",
            lat: '123',
            lng: '456'
          }
        ]
      }, instance_of(Taskrabbit::Api)).and_return(stub(save: true, id: 123))

      subject.save
    end

    it "sets the remote_task_id", :vcr do
      subject.save
      subject.reload.remote_task_id.should == 3
    end

    it "returns false if the task is not valid" do
      Taskrabbit::Task.should_receive(:new).and_return(stub(save: false))
      subject.save

      subject.new_record?.should == true
    end
  end
end
