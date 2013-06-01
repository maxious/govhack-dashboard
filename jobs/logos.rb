require 'net/http'
current_logo = 0
logo_list = Dir.glob("/var/www/disclogs/dashboard/assets/images/*").select { |fn| File.file?(fn) and !fn.end_with?("/logo.png") and !fn.end_with?("/logo.svg")}

SCHEDULER.every '30s' do
  if current_logo > logo_list.length or logo_list[current_logo].nil?
	current_logo = 0
  end
  uri = "/"+URI.escape(File.basename(logo_list[current_logo]))
  send_event('logos', { image: uri })
  current_logo = current_logo +1
end
