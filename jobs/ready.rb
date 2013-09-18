last_ready = 0
last_notready = 0
current_ready = 0
current_notready = 0
# http://hackerspace.govhack.org/?q=teams-by-region

require 'nokogiri'
require 'open-uri'

SCHEDULER.every '60s' do
last_ready = current_ready
last_notready = current_notready
current_ready = 0
current_notready = 0
doc = Nokogiri::HTML(open('http://hackerspace.govhack.org/?q=teams-by-region'))

doc.css('tr').each do |row|
        filled_cells = 0
        row.css('td').each do |cell|
                if cell.content.strip! != "" or cell.inner_html.include?("href")
                        filled_cells = filled_cells +1
                end
        end
        if filled_cells == 3
                current_ready = current_ready +1
        else
                current_notready = current_notready +1
        end
end


  send_event('ready', { current: current_ready, last: last_ready })
  send_event('notready', { current: current_notready, last: last_notready })
end
