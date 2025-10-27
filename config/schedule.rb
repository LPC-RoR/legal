# config/schedule.rb
every 1.day, at: '3:00 am' do
  rake 'licencias:marcar_expiradas'
end