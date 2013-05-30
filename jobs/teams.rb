current_teams = 0

SCHEDULER.every '30s' do
  last_teams     = current_teams
  current_teams     = `curl --silent http://hack.govhack.org/?q=groups | grep -c field-name-field-team-name`

  send_event('teams', { current: current_teams, last: last_teams })
end
