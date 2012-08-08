class User
  include Mongoid::Document
  field :remote_user_id, type: Integer
  field :display_name, type: String
  field :oauth_token, type: String

  has_many :reservations

  def self.find_or_create_from_auth_hash(auth_hash)
    user              = User.find_or_initialize_by(remote_user_id: auth_hash.uid)
    user.display_name = auth_hash.extra.raw_info.display_name
    user.oauth_token  = auth_hash.credentials.token
    user.save
    user
  end

  def remote_tasks
    api.tasks
  end

  private

  def api
    @api ||= Taskrabbit::Api.new(oauth_token)
  end
end
