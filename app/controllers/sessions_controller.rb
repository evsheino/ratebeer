class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_username params[:username]
    session[:user_id] = user.id if not user.nil?
    redirect_to user_path(user)
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
