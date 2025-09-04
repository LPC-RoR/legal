class HomeController < ApplicationController
  before_action :authenticate_usuario!, only: [:dshbrd]
  before_action :scrty_on, only: [:dshbrd]

  def index
		@objeto = Empresa.new
		@req = ComRequerimiento.new
		# @slides = Slide.activas.ordr

		@prfl_laborsafe = ComDocumento.find_by(codigo: 'prfl_laborsafe')
		@prfl_externalizacion = ComDocumento.find_by(codigo: 'prfl_externalizacion')

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

		# VERSIÓN ANTIGUA

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

  def artcls
  	@hsh = artcls_hsh[params[:tkn].to_sym]
  	
	  set_meta_tags(
	    title:       @hsh[:title],
	    description: @hsh[:description],
	    og: {
	      site_name:  'LaborSafe',
	      title:      @hsh[:title],
	      description:@hsh[:description],
	      type:       'article',
	      url:        "https://www.laborsafe.cl/artcls/#{params[:tkn]}",
	      image:      @hsh[:image_url]
	    }
		)
	end

  def costos
  	
  end

  private

  	def artcls_hsh
  		{
	  		costos: {
	  			image_url: view_context.image_url('artcls/costos_1920.jpg'),
	  			title: 'Los costos del incumplimiento',
	  			description: 'Descripción de costos',
	  			type: 'article',
	  		},
	  		externalizacion: {
	  			image_url: view_context.image_url('artcls/extrnlzcn_1920.jpg'),
	  			title: 'Externalizacion de investigaciones',
	  			description: 'Descripción de externalización',
	  			type: 'article',
	  		}
  		}
		end
end