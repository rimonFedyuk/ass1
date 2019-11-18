class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate
    @current_user = User.find_by(current_session_token: request.headers["Authorization"])
    return render Context::Response.new('user not found', :user_not_found, :unauthorized).perform unless @current_user
    true
  end

end
