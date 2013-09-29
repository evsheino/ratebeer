module SessionsHelper
  def current_user
    return User.find(session[:user_id]) if session[:user_id]
    nil
  end

  def signed_in?(user)
    user == current_user
  end

  def ensure_that_signed_in
    redirect_to signin_path, :alert => 'you should be signed in' if current_user.nil?
  end

  def ensure_that_admin
    redirect_to "/", :alert => 'Permission denied' unless current_user.admin?
  end
end
