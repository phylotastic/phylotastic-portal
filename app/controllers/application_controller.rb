class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_user
  
  def set_user
    if user_signed_in?
      @user = current_user
      @temp_id = nil
    else
      @user = User.anonymous      
      if cookies[:temp_id].nil?
        redirect_to root_path
        return
      end
      @temp_id = cookies[:temp_id]
    end
  end
  
end
