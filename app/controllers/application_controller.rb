require 'ostruct'

class ApplicationController < ActionController::Base

  private

  def current_user
    unless @current_user
      @current_user = OpenStruct.new(JSON.parse(session[:user])) if session[:user]
    end

    return @current_user
  end

  helper_method :current_user
end
