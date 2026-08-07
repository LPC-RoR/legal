class Aplicacion::HomeController < ApplicationController
	before_action :redirect_unauthenticated, only: :dshbrd
#  before_action :authenticate_usuario!, only: [:dshbrd]
  before_action :scrty_on, only: [:dshbrd]

  def index
  	prepare_meta_tags

    set_meta_tags(
      title: "Gestión de Denuncias Ley 21.643 | Plataforma Especializada",
      description: "Plataforma especializada para gestionar denuncias de la Ley 21.643 en Chile. Externalización de investigaciones, auditoría y capacitación.",
      keywords: %w[ley 21.643 gestión denuncias investigaciones laborales auditoría consultoría chile],
      canonical: root_url,
      og: {
        type: 'website',
        url: root_url,
        title: "LaborSafe - Gestión Profesional de Denuncias Ley 21.643",
        description: "Transforma la gestión de denuncias con cumplimiento automático de plazos y reportes normativos.",
        image: {
          _:  view_context.image_url('logo/logo_100.png'), # JPG/PNG 1200x630
          width: 392,
          height: 100,
          type: 'image/jpeg'
        }
      },
      twitter: {
        card: 'summary_large_image',
        title: "LaborSafe - Gestión de Denuncias Ley 21.643",
        description: "Plataforma especializada para empresas que gestionan denuncias bajo la Ley 21.643 en Chile.",
        image: view_context.image_url('logo/logo_100.png')
      }
    )

		@objeto = Empresa.new
		@req = ComRequerimiento.new
		# @slides = Slide.activas.ordr

#		@prsntcn = ComDocumento.find_by(codigo: 'presentacion')
#		@rprt_dnnc = ComDocumento.find_by(codigo: 'dnnc')

    @session_name = Digest::SHA1.hexdigest("#{session.id.to_s}#{Time.zone.today.to_s}")
 	
    # Puedes redirigir a dashboard si ya está autenticado
    if usuario_signed_in?
    	redirect_to authenticated_root_path and return
  	end

  	# =================== Variables para el timeline de plazos
    @fecha_base = parse_fecha_param || Time.zone.today
    @plazos_ejemplo = calcular_plazos_maximos(@fecha_base)
  	# =================== Variables para el timeline de plazos (final)

  	render layout: 'public'
  end
  
	def dshbrd
		@orgn = 'dshbrd'
		@usrs = Usuario.where(tenant_id: nil)

    set_tab( :tab, ['Pendientes', 'Realizados'])

    if @options[:tab] == 'Pendientes'
    	@pndnts = current_usuario.age_pendientes.where.not(estado: 'realizado').order(:created_at)
#    	@pndnts_danger 	= current_usuario.age_pendientes.where(estado: 'pendiente', prioridad: 'danger').order(:created_at)
#    	@pndnts_warning = current_usuario.age_pendientes.where(estado: 'pendiente', prioridad: 'warning').order(:created_at)
#    	@pndnts_success = current_usuario.age_pendientes.where(estado: 'pendiente', prioridad: 'success').order(:created_at)
#    	@pndnts_nuevos 	= current_usuario.age_pendientes.where(estado: 'pendiente', prioridad: nil).order(:created_at)
    else
    	@pndnts = current_usuario.age_pendientes.where(estado: 'realizado').order(:created_at)
    end

	  # 1. Salida temprana si el usuario está en un scope especial
	  if current_usuario&.tenant and ['Cliente', 'Empresa'].include?(current_usuario&.tenant.owner_type)
	    redirect_to "/cuentas/#{current_usuario&.tenant.owner_type[0].downcase}_#{current_usuario&.tenant.owner_id}/dnncs"
	    return               # <-- evita el doble render
	  end

	  @notas = current_usuario.notas_responsable.order(urgente: :desc,
	                                   pendiente: :desc,
	                                   created_at: :desc)

	  @actividades = AgeActividad.where('fecha > ?', Time.zone.today.beginning_of_day)
	                        .adncs
	                        .fecha_ordr

	  render layout: 'pltfrm'   # solo se ejecuta cuando no hubo redirect
	end

	def laborsafe
		@objeto = Empresa.new
		@req = ComRequerimiento.new

		render layout: 'public'
	end

	def guias
		@p = params[:p]

		if params[:p] == 'plzs'
			@hoy	 		= Date.today
			@hbls_30 	= CalFeriado.plazo_habil(@hoy, 30)
			@crrds_30 	= CalFeriado.plazo_corrido(@hoy, 30)
		end

		@objeto = Empresa.new
		@req = ComRequerimiento.new

		render layout: 'public'
	end

	def equipo
		render layout: 'public'
	end

	def blog
		render layout: 'public'
	end


	def artcls
  	@hsh = helpers.artcls_hsh[params[:tkn].to_sym]
  	
	  set_meta_tags(
	    title: @hsh[:title],
	    description: @hsh[:description],
	    og: {
	      title: @hsh[:title],
	      description: @hsh[:description],
	      image: @hsh[:image_url],
	      url: request.original_url
	    },
	    twitter: {
	      title: @hsh[:title],
	      description: @hsh[:description],
	      image: @hsh[:image_url]
	    }
	  )
	  end

  def costos
  end

  private

		def redirect_unauthenticated
		  return if usuario_signed_in?          # ya está logueado
		  redirect_to root_path and return      # redirige al index público
		end

	  def prepare_meta_tags(meta = {})
	    site = "LaborSafe"
	    defaults = {
	      site: site,
	      title: site,
	      reverse: true, # "Página | LaborSafe"
	      description: "Software para la gestión integral de procedimientos de investigación y sanción. Ley 21.643 (Ley Karin)",
	      canonical: request.original_url,
	      og: {
	        site_name: site,
	        type: 'website',
	        url: request.original_url,
	        image: view_context.image_url('logo/logo_150.png'),
	        locale: 'es_LA'
	      },
	      twitter: {
	        card: 'summary_large_image',
#	        site: '@tu_cuenta', # opcional
	      }
	    }
	    set_meta_tags defaults.merge(meta)
	  end

  def parse_fecha_param
    return nil if params[:fecha].blank?
    
    # Parseo explícito en zona horaria de Santiago
    Time.zone.parse(params[:fecha]).to_date
  rescue ArgumentError
    nil
  end

  def calcular_plazos_maximos(fecha_base)
    f_investigacion = CalFeriado.plazo_habil(fecha_base, 30)
    f_deposito      = CalFeriado.plazo_habil(f_investigacion, 2)
    f_pronunciamiento = CalFeriado.plazo_habil(f_deposito, 30)
    f_aplicacion    = CalFeriado.plazo_corrido(f_pronunciamiento, 15)

    [
      {
        numero: 1, nombre: 'Recepción de denuncia', dias: 3, tipo: 'hábiles',
        desde: fecha_base, hasta: CalFeriado.plazo_habil(fecha_base, 3),
        color: 'success', icono: 'bi-inbox', descripcion: 'Trámites propios de la recepción'
      },
      {
        numero: 2, nombre: 'Investigación', dias: 30, tipo: 'hábiles',
        desde: fecha_base, hasta: f_investigacion,
        color: 'primary', icono: 'bi-search', descripcion: 'Investigar los hechos denunciados'
      },
      {
        numero: 3, nombre: 'Depósito del informe', dias: 2, tipo: 'hábiles',
        desde: f_investigacion, hasta: f_deposito,
        color: 'info', icono: 'bi-upload', descripcion: 'Remitir informe a la Dirección del Trabajo'
      },
      {
        numero: 4, nombre: 'Pronunciamiento DT', dias: 30, tipo: 'hábiles',
        desde: f_deposito, hasta: f_pronunciamiento,
        color: 'warning', icono: 'bi-building', descripcion: 'Plazo legal para pronunciamiento de la DT'
      },
      {
        numero: 5, nombre: 'Aplicación de medidas', dias: 15, tipo: 'corridos',
        desde: f_pronunciamiento, hasta: f_aplicacion,
        color: 'danger', icono: 'bi-check2-square', descripcion: 'Aplicar medidas y sanciones propuestas'
      }
    ]
  end

end