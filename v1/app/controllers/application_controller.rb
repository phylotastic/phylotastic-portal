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
        cookies[:temp_id] = { value: ('a'..'z').to_a.shuffle[0,20].join, expires: 1.day.from_now }
      end
      @temp_id = cookies[:temp_id]
    end
  end
  
end
