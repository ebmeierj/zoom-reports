class ApplicationController < ActionController::Base

  private

  def current_user
    @current_user ||= session[:user]
  end

  helper_method :current_user
end
