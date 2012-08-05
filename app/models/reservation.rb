class Reservation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  FIXED_PRICE = 20

  field :time_to_call, type: String
  field :number_of_people, type: Integer
  field :remote_task_id, type: Integer
  field :user_id, type: Integer
  field :yelp_id, type: String
  field :reserve_at, type: DateTime
  field :location_name, type: String
  field :city, type: String
  field :zip, type: String
  field :address, type: String
  field :phone, type: String
  field :latitude, type: String
  field :longitude, type: String

  attr_accessible :yelp_id, :reserve_at, :latitude, :longitude, :location_name

  validates_presence_of :user_id
  belongs_to :user

  before_save :create_remote_task, :on => :create


  private 

  def create_remote_task
  end
end
