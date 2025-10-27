# lib/tasks/licencias.rake
namespace :licencias do
  desc 'Marca como expiradas las licencias vencidas'
  task marcar_expiradas: :environment do
    Licencia.marcar_expiradas!
  end
end