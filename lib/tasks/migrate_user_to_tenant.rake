# frozen_string_literal: true

namespace :migrate do
  desc 'Pasa usuarios a su tenant (Cliente/Empresa) y limpia emails'
  task users_to_tenant: :environment do
    emails_a_borrar = %w[
      admin@prueba.cl
      afiwugogida19@gmail.com
      finanzas@prueba.cl
      operacion@prueba.cl
      prueba@edasoft.cl
    ].map(&:downcase)

    rol_por_defecto = :admin

    puts 'Iniciando migración...'

    Usuario.find_each do |user|
      # 0. Borrar si está en la lista negra
      if emails_a_borrar.include?(user.email.downcase)
        puts "  ❌ Borrando #{user.email}"
        user.destroy
        next
      end

      # 1. ¿Está en alguna nómina?
      nomina = AppNomina.find_by(email: user.email.downcase)
      unless nomina
        puts "  ⚠️  #{user.email} no está en ninguna nómina → se salta"
        next
      end

      owner = nomina.ownr
      unless owner
        puts "  ⚠️  #{user.email} está en nómina sin owner → se salta"
        if user.roles.empty?
          case user.email.downcase
          when 'solange.mena@tapiaycia.cl', 'paula.donoso@tapiaycia.cl', 'francisco.tapia@tapiaycia.cl'
            safe_add_role(user, :admin, tenant)
          else
            safe_add_role(user, :operacion, tenant)
          end
          puts "  ✓ Rol asignado"
        end
        next
      end

      # 2. Crear tenant si no tiene
      if owner.tenant.nil?
        tenant = owner.build_tenant(nombre: owner.try(:razon_social) || owner.try(:nombre) || 'Tenant')
        tenant.save!
        puts "  ✓ Tenant creado para #{owner.class.name} ##{owner.id}"
      else
        tenant = owner.tenant
      end

      # 3. Asignar tenant al usuario
      user.update!(tenant: tenant)
      puts "  ✓ #{user.email} ahora pertenece al tenant ##{tenant.id}"

      # 4. Rol por defecto si no tiene ninguno
      if user.roles.empty?
        puts "  ⚠️  No se asigna rol porque no hay tenant válido"
      end

    end

    puts 'Migración finalizada.'
  end


  # helper local dentro de la task
  def safe_add_role(user, role_name, resource = nil)
    role = Role.find_or_create_by!(
      name: role_name.to_s,
      resource_type: resource&.class&.name,
      resource_id: resource&.id
    )
    user.add_role(role_name, resource)
  end
end