# config/initializers/first_user.rb

Rails.application.config.after_initialize do
  next unless defined?(Usuario) && Rails.application.credentials.dig(:dog).present?

  begin
    if Usuario.count.zero?
      dog = Rails.application.credentials.dog
      
      usuario = Usuario.new(
        email: dog[:email],
        password: dog[:password],
        password_confirmation: dog[:password],
        nombre: dog[:nombre],
        tenant_id: dog[:tenant_id] # Opcional: si quieres asignar tenant
      )
      
      # Confirmar email inmediatamente (evita que Devise pida confirmación)
      usuario.skip_confirmation!
      
      # Opcional: evitar bloqueo inicial si tienes lógica de lockable personalizada
      usuario.locked_at = nil
      usuario.failed_attempts = 0
      
      usuario.save!
      
      Rails.logger.info "✅ Usuario inicial creado: #{usuario.email} (confirmado: #{usuario.confirmed?})"
    end
  rescue ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished => e
    Rails.logger.debug "BD no disponible, saltando creación de usuario inicial"
  rescue StandardError => e
    Rails.logger.error "❌ Error creando usuario inicial: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
  end
end