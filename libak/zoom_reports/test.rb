require 'lib/zoom_reports/configure'

client = Zoom.new
my_user = client.user_list['users'].find { |it| it['email'] == 'ebmeierj@gmail.com' }
#my_meetings = client.meeting_list(user_id: my_user['id'])
#puts my_meetings.inspect
daily_report = client.daily_report()
puts daily_report.inspect
