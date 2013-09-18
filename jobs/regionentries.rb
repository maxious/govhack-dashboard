require 'nokogiri'
require 'open-uri'

regions = ["Total National","Adelaide","Brisbane","Canberra","Gold Coast", "Hobart","Melbourne","Perth","Sydney"]
#"Any" http://hackerspace.govhack.org/?q=prizes&field_group_region_tid=All
region_id = [15,16,17,18,19,20,21,22,23]
region_counts = Hash.new({ value: 0 })
current_id = 0
SCHEDULER.every '30s' do
#  random_region = region_id.sample
  if current_id > region_id.length or region_id[current_id].nil?
        current_id = 0
  end
random_region = region_id[current_id]
doc = Nokogiri::HTML(open('http://hackerspace.govhack.org/?q=prizes&field_group_region_tid='+random_region.to_s))
teams = []
doc.css('div.views-field-field-team-name').each do |link|
teams.push(link.content.strip!)
end

  region_counts[random_region] = { label: regions[region_id.index(random_region)], value: teams.uniq.size }
  
  send_event('regionentries', { items: region_counts.values })
current_id =current_id+1
end
