module ApiHelper
  def user_with_credit_card
    @user_with_credit_card ||= User.new(:oauth_token => ENV['OAUTH_TOKEN_USER_WITH_CREDIT_CARD'], :id => 1)
  end
end

RSpec.configuration.include ApiHelper