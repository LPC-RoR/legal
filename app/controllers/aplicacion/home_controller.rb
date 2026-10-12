class Aplicacion::HomeController < ApplicationController
  before_action :redirect_unauthenticated, only: :dshbrd
  before_action :scrty_on, only: [:dshbrd]
  before_action :set_meta_tags_publicos, only: %i[index metodologia laborsafe equipo simulador guias blog costos capacitaciones datos_personales datos_personales_karin legal_annm]
  before_action :set_json_ld_publicos, only: %i[index simulador guias costos]

  layout :resolve_home_layout   # anula el :resolve_layout de ApplicationController

  # ---------------------------------------------------------------
  # Datos SEO de las páginas públicas.
  # Ver reglas de edición en config/data/seo_publicas.yml.
  # ---------------------------------------------------------------
  SEO_PUBLICAS = YAML.load_file(
    Rails.root.join("config/data/seo_publicas.yml")
  ).deep_symbolize_keys.freeze

  # ---------------------------------------------------------------
  # Datos estructurados JSON-LD (schema.org)
  # Requiere gema meta-tags >= 2.19 (opción json_ld).
  # ---------------------------------------------------------------
  JSON_LD_SERVICIO_BASE = {
    "@context" => "https://schema.org",
    "@type"    => "LegalService",
    "name"     => "Laborsafe",
    "areaServed" => { "@type" => "Country", "name" => "Chile" },
    "description" => "Externalización de investigaciones de denuncias Ley 21.643 (Ley Karin) realizadas por abogados especialistas."
  }.freeze

  JSON_LD_FAQ_PLAZOS = {
    "@context" => "https://schema.org",
    "@type"    => "FAQPage",
    "mainEntity" => [
      {
        "@type" => "Question",
        "name"  => "¿Cuánto dura el procedimiento de investigación de la Ley 21.643?",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text"  => "El procedimiento tiene cinco etapas: recepción de la denuncia (3 días hábiles), investigación (30 días hábiles), depósito del informe ante la Dirección del Trabajo (2 días hábiles), pronunciamiento de la DT (30 días hábiles) y aplicación de medidas (15 días corridos)."
        }
      },
      {
        "@type" => "Question",
        "name"  => "¿Qué pasa si la empresa no cumple los plazos de la Ley 21.643?",
        "acceptedAnswer" => {
          "@type" => "Answer",
          "text"  => "El incumplimiento de los plazos y deberes del procedimiento puede ser sancionado por la Dirección del Trabajo y aumenta el riesgo de judicialización de la denuncia."
        }
      }
    ]
  }.freeze

  def index
    @lead = Lead.new
    @session_name = Digest::SHA1.hexdigest("#{session.id.to_s}#{Time.zone.today.to_s}")

    # Puedes redirigir a dashboard si ya está autenticado
    if usuario_signed_in?
      redirect_to authenticated_root_path and return
    end
  end

  def dshbrd
    @orgn = 'dshbrd'
    @usrs = Usuario.where(tenant_id: nil)

    set_tab(:tab, ['Pendientes', 'Realizados'])

    if @options[:tab] == 'Pendientes'
      @pndnts = current_usuario.age_pendientes.where.not(estado: 'realizado').order(:created_at)
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
  end

  def laborsafe
  end

  def guias
    @p = params[:p]

    if params[:p] == 'plzs'
      @hoy       = Date.today
      @hbls_30   = CalFeriado.plazo_habil(@hoy, 30)
      @crrds_30  = CalFeriado.plazo_corrido(@hoy, 30)
    end
  end

  def equipo
    @equipo = YAML.load_file(Rails.root.join("config/data/equipo.yml"))["abogados"]
    @coordinadores = @equipo.select { |a| a["rol"] == "coordinador" }
    @investigadores = @equipo.reject { |a| a["rol"] == "coordinador" }
  end

  def simulador
    preparar_simulacion
    @lead ||= Lead.new(fuente: "Simulador")
  end

  def enviar_simulacion
    preparar_simulacion
    @lead = Lead.new(lead_params.merge(fuente: "Simulador"))

    if @lead.save
      # Aviso interno (mailer existente)
      Comercial::LeadMailer.with(lead: @lead).nuevo_lead.deliver_later

      # Copia de la simulación para el lead
      Comercial::LeadMailer.with(
        lead: @lead,
        fecha_base: @fecha_base,
        plazos: @plazos_ejemplo,
        total_dias: (@plazos_ejemplo.last[:hasta] - @fecha_base).to_i
      ).copia_simulacion.deliver_later

      redirect_to simulador_path(fecha: @fecha_base.to_fs(:db), enviado: true),
                  notice: "Listo. Te enviamos una copia de la simulación a tu correo."
    else
      render :simulador, status: :unprocessable_entity
    end
  end

  def marco_legal
    @cuerpo_principal   = ClssHome.cuerpo_principal
    @docs_referencia    = ClssHome.docs_referencia
    @leyes_modificadas  = ClssHome.leyes_modificadas
    @otros_documentos   = ClssHome.otros_documentos
  end

  def datos_personales
    @docs_ley_vigente = ClssHome.datos_personales_vigente
    @docs_ley_21719   = ClssHome.datos_personales_ley_21719
  end

  def datos_personales_karin
  end

  def legal_annm
    @docs_normas_datos       = ClssHome.annm_normas_datos
    @docs_normas_especificas = ClssHome.annm_normas_especificas
    @fallos_corte_suprema    = ClssHome.annm_fallos_corte_suprema
    @docs_complementarios    = ClssHome.annm_docs_complementarios
  end

  def metodologia
  end

  def capacitaciones
  end

  def blog
  end

  def artcls
    @hsh = helpers.artcls_hsh[params[:tkn].to_sym]

    set_meta_tags(
      title: @hsh[:title],
      description: @hsh[:description],
      canonical: request.original_url,   # evita URLs duplicadas indexables
      og: {
        title: @hsh[:title],
        description: @hsh[:description],
        image: @hsh[:image_url] || helpers.image_url("og/og-default.png"),
        url: request.original_url
      },
      twitter: {
        title: @hsh[:title],
        description: @hsh[:description],
        image: @hsh[:image_url] || helpers.image_url("og/og-default.png")
      }
    )
  end

  def costos
  end

  private

  def resolve_home_layout
    action_name == 'dshbrd' ? 'pltfrm' : 'public'
  end

  # ---------------------------------------------------------------
  # Meta tags por página pública. Usa los defaults globales que ya
  # dejó before_action :prepare_meta_tags (ApplicationController) y
  # solo sobrescribe lo específico de cada página.
  # ---------------------------------------------------------------
  def set_meta_tags_publicos
    seo = SEO_PUBLICAS[action_name.to_sym]
    return if seo.blank?

    url        = send(seo[:canonical])              # p. ej. metodologia_url
    og_image   = og_image_url(seo[:og_image])
    og_title   = seo[:og_title] || seo[:title]

    set_meta_tags(
      title: seo[:title],
      description: seo[:description],
      keywords: seo[:keywords],
      canonical: url,
      og: {
        title: og_title,
        description: seo[:description],
        url: url,
        image: og_image,
        type: "website",
        locale: "es_CL"
      },
      twitter: {
        card: "summary_large_image",
        title: og_title,
        description: seo[:description],
        image: og_image
      }
    )
  end

  # ---------------------------------------------------------------
  # Imagen OG con fallback: si el asset específico de la página no
  # existe, usa og-default.png. Así un archivo faltante nunca tumba
  # la página con Propshaft::MissingAssetError.
  # Las imágenes viven en app/assets/images/og/
  # ---------------------------------------------------------------
  OG_IMAGES_DIR = "og".freeze

  def og_image_url(nombre)
    archivo = nombre.to_s.presence || "og-default.png"
    unless Rails.root.join("app/assets/images", OG_IMAGES_DIR, archivo).exist?
      archivo = "og-default.png"
    end
    helpers.image_url("#{OG_IMAGES_DIR}/#{archivo}")
  end

  # ---------------------------------------------------------------
  # Datos estructurados por página. Complementa (no reemplaza) los
  # meta tags; schema.org mejora la elegibilidad de rich results.
  # ---------------------------------------------------------------
  def set_json_ld_publicos
    json_ld =
      case action_name
      when "index", "costos" then JSON_LD_SERVICIO_BASE.merge("url" => root_url)
      when "simulador", "guias" then JSON_LD_FAQ_PLAZOS
      end

    set_meta_tags(json_ld: json_ld) if json_ld.present?
  end

  # --------------------------- Métodos para el simulador
  def preparar_simulacion
    @fecha_base     = parsear_fecha(params[:fecha]) || Time.zone.today
    @plazos_ejemplo = SimulacionPlazos.calcular(@fecha_base)
  end

  def parsear_fecha(valor)
    Date.iso8601(valor.to_s)
  rescue ArgumentError
    nil
  end
  # --------------------------- Métodos para el simulador (final)

  def redirect_unauthenticated
    return if usuario_signed_in?          # ya está logueado
    redirect_to root_path and return      # redirige al index público
  end

  def parse_fecha_param
    return nil if params[:fecha].blank?

    # Parseo explícito en zona horaria de Santiago
    Time.zone.parse(params[:fecha]).to_date
  rescue ArgumentError
    nil
  end

  def calcular_plazos_maximos(fecha_base)
    f_investigacion   = CalFeriado.plazo_habil(fecha_base, 30)
    f_deposito        = CalFeriado.plazo_habil(f_investigacion, 2)
    f_pronunciamiento = CalFeriado.plazo_habil(f_deposito, 30)
    f_aplicacion      = CalFeriado.plazo_corrido(f_pronunciamiento, 15)

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

  def lead_params
    # Rails 8: params.expect. Si prefieres el API clásico:
    # params.require(:lead).permit(:nombre, :email, :telefono, :empresa)
    params.expect(lead: [:nombre, :email, :telefono, :empresa])
  end
end