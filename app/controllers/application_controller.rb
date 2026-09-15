class ApplicationController < ActionController::Base
  layout :resolve_layout

  DEFAULT_DESCRIPTION = "Software para la gestión integral de procedimientos de investigación y sanción. Ley 21.643 (Ley Karin)".freeze
  DEFAULT_OG_IMAGE = 'og/og_laborsafe.png'.freeze

  before_action :redirect_to_canonical_host
  before_action :prepare_meta_tags, if: -> { request.format.html? }

  include SetCurrentTenant
#  include Pundit
  include Pundit::Authorization   # <-- línea clave

#	helper PdfHelper
	include PdfHelper

  include DeviseTurboFix

	include Config
	include Seguridad

	include Inicia
	include IniciaAplicacion

	include Crstn
	include Capitan
	include Tablas
	include Cmenu
	include Paths


	include Calendario

	include Tarifas

  def pundit_user
    current_usuario        # <-- clave
  end

	# Seguridad tabla_path
	helper_method :get_version_activa, :get_app_sigla, :get_perfil_activo
	helper_method :get_scp_activo
	helper_method :scp_err?, :scp_activo?, :dog_perfil, :dog_perfil?, :tipo_usuario, :version_activa, :version_activa?, :nomina_activa, :nomina_activa?, :perfil_activo, :perfil_activo?, :usuario_agenda, :usuario_agenda?
	helper_method :dog?, :admin?, :usuario_activo?, :publico?, :seguridad 
	helper_method :operacion?, :finanzas?
	helper_method :vlr_uf, :uf_fecha, :enlaces_general, :v_enlaces_general, :enlaces_perfil, :v_enlaces_perfil, :v_enlaces
	helper_method :arriba, :abajo, :reordenar
	helper_method :params_to_date, :dt_hoy
	helper_method :swtch_urgencia, :swtch_pendiente
	helper_method :set_formulas, :vlr_cuantia, :vlr_tarifa, :get_total_cuantia 
	helper_method :get_fecha_calculo, :leyenda_origen_fecha_calculo, :get_uf_calculo, :get_tar_facturacion, :get_monto_calculo_pesos, :get_monto_calculo_uf
	helper_method :nombre_dia, :dyf, :prfx_dia
	helper_method :cfg_defaults, :cfg_navbar, :cfg_color, :cfg_fonts
	helper_method :cmenu_clss, :std, :typ, :display_name, :scp_menu, :scp_item
	helper_method :krn_fl_cntrl, :krn_cntrllrs?, :drvcn_text
	helper_method :to_name, :corrige
	helper_method :bck_path_krn_objt
	helper_method :cntxt_bck_rdrctn, :shw_cnt_tab_indx, :shw_dnnc_tab_indx, :shw_clnt_tab

  private

	def redirect_to_canonical_host
	  return unless Rails.env.production?
	  canonical_host = "www.laborsafe.cl"
	  if request.host != canonical_host
	    redirect_to "https://#{canonical_host}#{request.fullpath}",
	                status: :moved_permanently, allow_other_host: true
	  end
	end

  def resolve_layout
    devise_controller? ? 'devise' : 'application'
  end

  def prepare_meta_tags(meta = {})
    site = "Laborsafe"
    defaults = {
      site: site,
      title: meta[:title] || site,
      description: meta[:description] || DEFAULT_DESCRIPTION,
      reverse: true, # "Título | Laborsafe"
      canonical: meta[:canonical] || request.original_url,
      og: {
        site_name: site,
        title: meta[:og_title] || meta[:title] || site,
        description: meta[:og_description] || meta[:description] || DEFAULT_DESCRIPTION,
        type: meta[:type] || 'website',
        url: meta[:canonical] || request.original_url,
        image: meta[:image] || view_context.image_url(DEFAULT_OG_IMAGE),
        locale: 'es_LA'
      },
      twitter: {
        card: 'summary_large_image',
        title: meta[:og_title] || meta[:title] || site,
        description: meta[:description] || DEFAULT_DESCRIPTION,
        image: meta[:image] || view_context.image_url(DEFAULT_OG_IMAGE)
      }
    }
    set_meta_tags defaults
  end
  
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:usuario, request.fullpath)
  end

end