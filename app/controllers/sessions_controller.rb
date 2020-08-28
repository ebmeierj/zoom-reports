require 'json'

class SessionsController < ApplicationController
  def create
    begin
      @user = user_from_onmiauth(request.env['omniauth.auth'])
      session[:user] = @user.to_json
      flash[:success] = "Welcome, #{@user[:first_name]}"
    rescue => e
      puts e
      flash[:warning] = "There was an error while trying to authenticate you"
    end

    redirect_to root_path
  end

  def destroy
    if current_user
      session.delete(:user)
      flash[:success] = "Logout successful"
    end

    redirect_to root_path
  end

  private

  def user_from_onmiauth(auth_hash)
    {
      uid: auth_hash.uid,
      provider: auth_hash.provider,
      first_name: auth_hash.extra.raw_info.first_name,
      last_name: auth_hash.extra.raw_info.last_name,
      status: auth_hash.extra.raw_info.status,
      language: auth_hash.extra.raw_info.language,
      email: auth_hash.extra.raw_info.email,
      phone_number: auth_hash.extra.raw_info.phone_number,
      timezone: auth_hash.extra.raw_info.timezone,
      image_url: auth_hash.extra.raw_info.pic_url,
      token: auth_hash.credentials.token
    }
  end
end
