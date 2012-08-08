class Reservation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  FIXED_PRICE = 20

  field :party_size, type: Integer
  field :remote_task_id, type: Integer
  field :user_id, type: Integer
  field :yelp_id, type: String
  field :reserve_at, type: DateTime
  field :location_name, type: String
  field :city, type: String
  field :zip, type: String
  field :state, type: String
  field :address, type: String
  field :phone, type: String
  field :latitude, type: String
  field :longitude, type: String

  attr_accessible :yelp_id, :reserve_at, :latitude, :longitude, 
                  :location_name, :party_size

  validates_presence_of :user_id, :party_size, :location_name, :reserve_at
  belongs_to :user

  before_save :create_remote_task, :on => :create

  def taskified_title
    return '' if location_name.blank? or reserve_at.blank?
    "Make a reservation to #{location_name} for #{formatted_reservation_time}"
  end

  def taskified_description
    description = <<-TEXT
    I am looking for a TaskRabbit to go to #{location_name} to make a reservation for #{formatted_reservation_time}.
    The party is of #{party_size}.
    Please call me when you arrive at the restaurant to tell me when I would have to come.

    Thank you.

    Task Posted on saveaspotfor.me
    TEXT

    description.gsub!(/ +/, ' ').strip!
  end

  private 

  def create_remote_task
    remote_task = user.remote_tasks.new(
      name: taskified_title,
      description: taskified_description,
      named_price: Reservation::FIXED_PRICE,
      other_locations_attributes: [
        {
          name: location_name,
          address: address,
          city: city,
          state: state,
          zip: zip,
          lat: latitude,
          lng: longitude
        }
      ]
    )
    return false unless remote_task.save
    self.remote_task_id = remote_task.id
    true
  end

  def formatted_reservation_time
    I18n.l(reserve_at, :format => :sentence).gsub(/\s+/, ' ')
  end
end
