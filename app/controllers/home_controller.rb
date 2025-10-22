class HomeController < ApplicationController
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

		@prfl_laborsafe = ComDocumento.find_by(codigo: 'prfl_laborsafe')
		@prfl_externalizacion = ComDocumento.find_by(codigo: 'prfl_externalizacion')
		@rprt_dnnc = ComDocumento.find_by(codigo: 'dnnc')

    @session_name = Digest::SHA1.hexdigest("#{session.id.to_s}#{Time.zone.today.to_s}")
 	
    # Puedes redirigir a dashboard si ya está autenticado
    if usuario_signed_in?
    	redirect_to authenticated_root_path and return
  	end

  	render layout: 'public'
  end
  
	def dshbrd
	  # 1. Salida temprana si el usuario está en un scope especial
	  if ['Cliente', 'Empresa'].include?(current_usuario&.tenant.owner_type)
	    redirect_to "/cuentas/#{current_usuario&.tenant.owner_type[0].downcase}_#{current_usuario&.tenant.owner_id}/dnncs"
	    return               # <-- evita el doble render
	  end

	  # 2. Resto de la lógica del dashboard
	  prfl = get_perfil_activo
	  @usuario = prfl.age_usuario unless prfl.blank?
	  @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

	  unless @usuario.blank?
	    set_tabla('notas',
	              @usuario.notas.order(urgente: :desc,
	                                   pendiente: :desc,
	                                   created_at: :desc),
	              false)
	  end

	  set_tabla('age_actividades',
	            AgeActividad.where('fecha > ?', Time.zone.today.beginning_of_day)
	                        .adncs
	                        .fecha_ordr,
	            false)

	  @hoy = Time.zone.today
	  @estados = nil
	  @tipos  = ['Causas', 'Pagos', 'Facturas']
	  @tipo   = params[:t].presence || @tipos[0]
	  @estado = nil
	  @path   = '/?'

	  inicia_sesion if perfil_activo.blank?

	  if operacion?
	    set_tabla('tramitacion-causas', Causa.where(estado: 'tramitación'), false)
	    @causas_en_proceso = Causa.where(estado: 'tramitación')
	  end

	  render layout: 'addt'   # solo se ejecuta cuando no hubo redirect
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

		def redirect_unauthenticated
		  return if usuario_signed_in?          # ya está logueado
		  redirect_to root_path and return      # redirige al index público
		end

  	def artcls_hsh
  		{
	  		costos: {
	  			image_url: image_url('artcls/costos_1200.jpg'),
	  			title: 'Los costos del incumplimiento',
	  			description: 'Crear un canal de denuncias, diseñar e implementar medidas de resguardo, contar con -al menos- un investigador con las competencias necesarias, cumplir con las exigencias formales de una investigación, entre otros, son desafíos aún presentes tras un año de vigencia de la ley. Su implementación o perfeccionamiento en el tiempo, si bien tendrá estándares distintos en cada empresa, buscará siempre satisfacer una exigencia mínima: evitar los costos asociados al incumplimiento de la ley.'.truncate(160),
	  			type: 'article',
	  		},
	  		externalizacion: {
	  			image_url: image_url('artcls/extrnlzcn_1200.jpg'),
	  			title: 'Externalizacion de investigaciones',
	  			description: 'La externalización de investigaciones es la modalidad en la cual se delega a una empresa externa la realización de la investigación. Si bien, solo es posible utilizarla en los casos investigados por la propia empresa, puede ser una buena alternativa dadas sus ventajas financieras y operativas.'.truncate(160),
	  			type: 'article',
	  		}
  		}
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
	        image: view_context.image_url('logo/logo_100.png'),
	        locale: 'es_LA'
	      },
	      twitter: {
	        card: 'summary_large_image',
#	        site: '@tu_cuenta', # opcional
	      }
	    }
	    set_meta_tags defaults.merge(meta)
	  end
end