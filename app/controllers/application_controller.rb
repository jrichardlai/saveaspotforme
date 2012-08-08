class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_user
  before_filter :ensure_session

  helper_method :current_user

  def current_user
    @current_user ||= User.where(id: session[:current_user_id]).first
  end

  protected

  def require_login
    redirect_to(root_path, {:error => "Need to be logged in"}) unless current_user
  end

  def ensure_session
    session ||= {}
  end
end
