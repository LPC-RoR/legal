# lib/tasks/fix_dog_role.rake
namespace :migrate do
  desc 'Asigna rol :dog global a hugo.chinga.g@gmail.com sin tocar su tenant'
  task fix_dog_role: :environment do
    user = Usuario.find_by(email: 'hugo.chinga.g@gmail.com')

    unless user
      puts "Usuario no encontrado"
      exit
    end

    # Opcional: quitar roles previos sobre su tenant actual
    user.roles.where(resource: user.tenant).destroy_all

    # Asignar :dog global (sin recurso)
    user.add_role(:dog)

    puts "✅ Rol :dog (global) asignado a #{user.email}"
    puts "   Tenant actual: #{user.tenant_id} (#{user.tenant&.owner_type})"
  end
end