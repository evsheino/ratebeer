module SessionsHelper
  def current_user
    return User.find(session[:user_id]) if session[:user_id]
    nil
  end

  def signed_in?(user)
    user == current_user
  end
end
