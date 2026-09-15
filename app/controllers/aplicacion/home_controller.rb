class Aplicacion::HomeController < ApplicationController
  before_action :redirect_unauthenticated, only: :dshbrd
  before_action :scrty_on, only: [:dshbrd]
  before_action :set_meta_tags_publicos, only: %i[metodologia laborsafe equipo simulador guias blog costos]

  # ---------------------------------------------------------------
  # Datos SEO de las páginas públicas
  # Nota: NO incluir "| Laborsafe" en :title — prepare_meta_tags
  # (ApplicationController) define site: "Laborsafe" con reverse: true
  # y agrega la marca automáticamente.
  # ---------------------------------------------------------------
  SEO_PUBLICAS = {
    metodologia: {
      title: "Etapas y plazos del procedimiento Ley 21.643",
      description: "Las cinco etapas del procedimiento Ley 21.643: plazos legales, responsables y el aporte de Laborsafe en la investigación, depósito y aplicación de medidas.",
      keywords: %w[procedimiento ley 21.643 etapas plazos ley karin investigación dirección del trabajo],
      canonical: :metodologia_url
    },
    laborsafe: {
      title: "Plataforma tecnológica para investigaciones Ley 21.643",
      description: "Plataforma para gestionar el procedimiento Ley 21.643: control de plazos, carpeta electrónica trazable, confidencialidad por diseño y documentos de abogados.",
      keywords: %w[plataforma ley 21.643 software denuncias gestión investigación carpeta electrónica],
      canonical: :laborsafe_url
    },
    equipo: {
      title: "Equipo legal de abogados especialistas Ley 21.643",
      description: "Conozca al equipo legal de Laborsafe: abogados especialistas en derecho laboral y en la conducción de investigaciones ante la Dirección del Trabajo.",
      keywords: %w[abogados especialistas ley 21.643 derecho laboral investigadores],
      canonical: :equipo_url
    },
    simulador: {
      title: "Simulador de plazos del procedimiento Ley 21.643",
      description: "Simule gratis las fechas límite de las cinco etapas del procedimiento Ley 21.643 y reciba el detalle proyectado en su correo.",
      keywords: %w[simulador plazos ley 21.643 calculadora días hábiles ley karin],
      canonical: :simulador_url,
      og_title: "Simulador gratuito: plazos del procedimiento Ley 21.643"
    },
    guias: {
      title: "Guías prácticas sobre la Ley 21.643",
      description: "Guías prácticas sobre la Ley 21.643: plazos del procedimiento, deberes del canal de denuncias y buenas prácticas para investigar denuncias laborales en Chile.",
      keywords: %w[guías ley 21.643 ley karin canal de denuncias plazos],
      canonical: :guias_url
    },
    blog: {
      title: "Blog y actualidad sobre la Ley 21.643",
      description: "Actualidad, análisis y consejos prácticos sobre la Ley 21.643, el procedimiento de investigación de denuncias laborales y su implementación en las empresas.",
      keywords: %w[blog ley 21.643 ley karin denuncias laborales],
      canonical: :blog_url
    },
    costos: {
      title: "Planes y modalidades de externalización",
      description: "Conozca los planes y modalidades de contratación del servicio de externalización de investigaciones Ley 21.643. Solicite una presentación comercial.",
      keywords: %w[planes precios externalización investigaciones ley 21.643],
      canonical: :costos_url
    }
  }.freeze

  def index
    set_meta_tags(
      title: "Externalización de investigaciones Ley 21.643",
      description: "Externalice las investigaciones de sus denuncias Ley 21.643 (Ley Karin) con abogados especialistas: minimice riesgos de judicialización, cumpla los plazos legales y proteja la confidencialidad del procedimiento.",
      keywords: %w[externalización investigaciones ley 21.643 ley karin denuncias acoso laboral investigador externo chile],
      canonical: root_url,
      og: {
        title: "Laborsafe - Externalización de investigaciones Ley 21.643",
        description: "Investigaciones de denuncias Ley 21.643 realizadas por abogados especialistas, con control de plazos, confidencialidad y documentos redactados por expertos."
      },
      twitter: {
        title: "Laborsafe - Externalización de investigaciones Ley 21.643",
        description: "Investigaciones de denuncias Ley 21.643 realizadas por abogados especialistas."
      }
    )

    @lead = Lead.new
    @session_name = Digest::SHA1.hexdigest("#{session.id.to_s}#{Time.zone.today.to_s}")

    # Puedes redirigir a dashboard si ya está autenticado
    if usuario_signed_in?
      redirect_to authenticated_root_path and return
    end

    render layout: 'public'
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

    render layout: 'pltfrm'   # solo se ejecuta cuando no hubo redirect
  end

  def laborsafe
    render layout: 'public'
  end

  def guias
    @p = params[:p]

    if params[:p] == 'plzs'
      @hoy       = Date.today
      @hbls_30   = CalFeriado.plazo_habil(@hoy, 30)
      @crrds_30  = CalFeriado.plazo_corrido(@hoy, 30)
    end

    render layout: 'public'
  end

  def equipo
    @equipo = YAML.load_file(Rails.root.join("config/data/equipo.yml"))["abogados"]
    @coordinadores = @equipo.select { |a| a["rol"] == "coordinador" }
    @investigadores = @equipo.reject { |a| a["rol"] == "coordinador" }

    render layout: 'public'
  end

  def simulador
    preparar_simulacion
    @lead ||= Lead.new(fuente: "Simulador")

    render layout: 'public'
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

  def metodologia
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

  # ---------------------------------------------------------------
  # Meta tags por página pública. Usa los defaults globales que ya
  # dejó before_action :prepare_meta_tags (ApplicationController) y
  # solo sobrescribe lo específico de cada página.
  # ---------------------------------------------------------------
  def set_meta_tags_publicos
    seo = SEO_PUBLICAS[action_name.to_sym]
    return if seo.blank?

    url = send(seo[:canonical]) # p. ej. metodologia_url

    set_meta_tags(
      title: seo[:title],
      description: seo[:description],
      keywords: seo[:keywords],
      canonical: url,
      og: {
        title: seo[:og_title] || seo[:title],
        description: seo[:description],
        url: url
      },
      twitter: {
        title: seo[:og_title] || seo[:title],
        description: seo[:description]
      }
    )
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