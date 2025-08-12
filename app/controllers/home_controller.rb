class HomeController < ApplicationController
  before_action :authenticate_usuario!, only: [:dshbrd]
    before_action :scrty_on, only: [:dshbrd]

  def index
		@objeto = Empresa.new
		@slides = Slide.activas.ordr

		# Precargamos los variants para mejor performance
		if @slides.any?
		  # Nuevas dimensiones basadas en 1920x528 (manteniendo la relación 1200:330 pero en HD)
		  variants = [
		    [400, 110],    # Mobile (400w) - mantiene relación (400/1920*528 ≈ 110)
		    [800, 220],     # Tablet (800w)
		    [1200, 330],    # Desktop pequeño
		    [1600, 440],    # Desktop medio
		    [1920, 528]     # Desktop full HD (tamaño original)
		  ]
		  
		  @slides.each do |slide|
		    if slide.imagen.attached?
		      variants.each do |width, height|
		        begin
		          # Precargamos el variant con la nueva configuración
		          variant = slide.imagen.variant(
		            resize_to_limit: [width, height],
		            saver: { quality: 80 }  # Opcional: compresión para web
		          ).processed
		          
		          # Precarga adicional para formato WebP (opcional pero recomendado)
		          if defined?(ImageProcessing::Vips)
		            slide.imagen.variant(
		              format: :webp,
		              resize_to_limit: [width, height],
		              saver: { quality: 75, effort: 6 }
		            ).processed
		          end
		        rescue => e
		          Rails.logger.error "Error procesando variant #{width}x#{height} para slide #{slide.id}: #{e.message}"
		        end
		      end
		    end
		  end
		end    

    @session_name = Digest::SHA1.hexdigest("#{session.id.to_s}#{Time.zone.today.to_s}")
 	
    # Puedes redirigir a dashboard si ya está autenticado
    redirect_to authenticated_root_path if usuario_signed_in?
  end
  
  def dshbrd

  	redirect_to "/cuentas/#{nomina_activa.ownr.class.name[0].downcase}_#{nomina_activa.ownr.id}/dnncs" if scp_activo?

		prfl = get_perfil_activo
		@usuario = prfl.age_usuario unless prfl.blank?
		@age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

		unless @usuario.blank?
			set_tabla('notas', @usuario.notas.order(urgente: :desc, pendiente: :desc, created_at: :desc), false)
		end

		set_tabla('age_actividades', AgeActividad.where('fecha > ?', Time.zone.today.beginning_of_day).adncs.fecha_ordr, false)

		@hoy = Time.zone.today
		@age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

		# VERSIÖN ANTIGUA

		@estados = nil
		@tipos = ['Causas', 'Pagos', 'Facturas']
		@tipo = params[:t].blank? ? @tipos[0] : params[:t]
		@estado = nil
		@path = "/?"

		inicia_sesion if perfil_activo.blank?

		if operacion?
			# Causas
			set_tabla('tramitacion-causas', Causa.where(estado: 'tramitación'), false)
			@causas_en_proceso = Causa.where(estado: 'tramitación')
		end
  end

  def costos
  	
  end
end