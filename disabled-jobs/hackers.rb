current_hackers = 0
last_hackers = 0

SCHEDULER.every '30s' do
  last_hackers     = current_hackers
  current_hackers     = `curl --silent http://hack.govhack.org/?q=hackers | grep -c views-row`

  send_event('hackers', { current: current_hackers, last: last_hackers })
end
