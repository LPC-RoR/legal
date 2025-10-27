# lib/tasks/empresas.rake
namespace :empresas do
  desc 'Crear demo a empresas que no tienen ninguna licencia'
  task crear_demos: :environment do
    Empresa.left_outer_joins(:licencias)
           .where(licencias: { id: nil })
           .find_each do |empresa|
      empresa.licencias.create!(
        plan:          'demo',
        status:        'active',
        max_denuncias: 5,
        started_at:    Time.current,
        finished_at:   10.days.from_now
      )
      puts "Demo creada para empresa #{empresa.id} – #{empresa.razon_social}"
    end
  end
end