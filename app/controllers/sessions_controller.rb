class SessionsController < ApplicationController
  def create
    begin
      @user = user_from_onmiauth(request.env['omniauth.auth'])
      session[:user] = @user
      logger.error "SET SESSION TO #{session[:user]}"
      flash[:success] = "Welcome, #{@user[:name]}"
    rescue
      flash[:warning] = "There was an error while trying to authenticate you"
    end
    redirect_to root_path
  end

  def destroy
    if current_user
      @name = session[:user][:name]
      session.delete(:user)
      flash[:success] = "#{name} has been logged out"
    end
    redirect_to root_path
  end

  private

  def user_from_onmiauth(auth_hash)
    {
      uid: auth_hash['uid'],
      provider: auth_hash['provider'],
      name: auth_hash['info']['name'],
      location: auth_hash['info']['location'],
      image_url: auth_hash['info']['image'],
      url: auth_hash['info']['urls']
    }
  end
end
