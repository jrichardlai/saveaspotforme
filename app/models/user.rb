class User
  include Mongoid::Document
  field :remote_user_id, type: Integer
  field :display_name, type: String

  has_many :reservations

  def self.find_or_create_from_auth_hash(auth_hash)
    user              = find_or_initialize_by_remote_id(auth_hash.uid)
    user.display_name = auth_hash.extra.raw_info.display_name
    user.save
    user
  end

end
