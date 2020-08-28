require 'base64'
require 'zoom'

class PagesController < ApplicationController
  def index
    @meetings = load_meetings if current_user
  end

  def load_meetings
    client = Zoom::Client::OAuth.new(access_token: current_user.token)
    client.meeting_list(user_id: current_user.uid)['meetings'].map { |it|
      {
        topic: it['topic'],
        start_time: it['start_time'],
        duration: it['duration'],
        url: it['join_url']
      }
    }
  rescue => e
    puts "#{e.message}\n#{e.backtrace.join("\n")}"
    flash[:warning] = "Unable to load meetings"
    []
  end
end
