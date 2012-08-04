class Reservation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :remote_task_id, type: Integer
  field :user_id, type: Integer
  field :yelp_id, type: String
  field :reserve_at, type: DateTime
  field :restaurant_name, type: String
  field :city, type: String
  field :zip, type: String
  field :address, type: String
  field :phone, type: String
  field :latitude, type: String
  field :longitude, type: String

  validates_presence_of :user_id
  belongs_to :user
end
