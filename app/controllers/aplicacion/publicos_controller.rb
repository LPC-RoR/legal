class Aplicacion::PublicosController < ApplicationController
  before_action :authenticate_usuario!, only: %i[ home2 encuesta preguntas ]
  before_action :scrty_on, only: %i[ home home_prueba encuesta preguntas ]
  before_action :set_publico, only: %i[ show edit update destroy ]
  before_action :inicia_sesion, only: [:home]

  # GET /publicos or /publicos.json
  def index
  end

  def home
    if usuario_signed_in?
      @usuario = get_perfil_activo.age_usuario
      @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

      set_tabla('notas', @usuario.notas.order(urgente: :desc, pendiente: :desc, created_at: :desc), false)

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

      if finanzas?
        # Causas
        csf_ids = Causa.all.map {|causa| causa.id if causa.tar_facturaciones.empty?}.compact
        set_tabla('sin_facturar-causas', Causa.where(id: csf_ids), false)

        # Cargos o facturaciones
#        set_tabla('sin_aprobacion-tar_facturaciones', TarFacturacion.where(tar_aprobacion_id: nil, tar_factura_id: nil), false)
#        set_tabla('sin_facturar-tar_facturaciones', TarFacturacion.where(tar_factura_id: nil).where.not(tar_aprobacion_id: nil), false)

        # Facturas
        set_tabla('por_emitir-tar_facturas', TarFactura.where(estado: 'ingreso').order(fecha_factura: :desc), false)
        set_tabla('en_cobranza-tar_facturas', TarFactura.where(estado: 'facturada').order(fecha_factura: :desc), false)

        # chartkick de facturación
        @facturacion = {
          'ene 2023' => 0,
          'feb 2023' => 0,
          'mar 2023' => 0,
          'abr 2023' => 0,
          'may 2023' => 0,
          'jun 2023' => 0,
          'jul 2023' => 0,
          'ago 2023' => 0,
          'sep 2023' => 0,
          'oct 2023' => 0,
          'nov 2023' => 0,
          'dic 2023' => 0
        }

        facturas = TarFactura.where.not(estado: 'ingreso')
        facturas.each do |factura|
          case factura.fecha_factura.month
          when 1
            @facturacion['ene 2023'] += factura.monto_corregido
          when 2
            @facturacion['feb 2023'] += factura.monto_corregido
          when 3
            @facturacion['mar 2023'] += factura.monto_corregido
          when 4
            @facturacion['abr 2023'] += factura.monto_corregido
          when 5
            @facturacion['may 2023'] += factura.monto_corregido
          when 6
            @facturacion['jun 2023'] += factura.monto_corregido
          when 7
            @facturacion['jul 2023'] += factura.monto_corregido
          when 8
            @facturacion['ago 2023'] += factura.monto_corregido
          when 9
            @facturacion['sep 2023'] += factura.monto_corregido
          when 10
            @facturacion['oct 2023'] += factura.monto_corregido
          when 11
            @facturacion['nov 2023'] += factura.monto_corregido
          when 12
            @facturacion['dic 2023'] += factura.monto_corregido
          end
        end
      end

    else
      @session_name = Digest::SHA1.hexdigest("#{session.id.to_s}#{Time.zone.today.to_s}")

      @hlp_rgstr_emprs = RepArchivo.find_by(rep_archivo: 'hlp_rgstr_emprs')

#      articulos = BlgArticulo.all.order(created_at: :desc)
#      @principal = articulos.first
#      @segundo = articulos.second
#      @tercero = articulos.third
    end
    @session_name = Digest::SHA1.hexdigest("#{session.id.to_s}#{Time.zone.today.to_s}")

  end

  def home_prueba
    @txts = {}
    ['rsmn_ly21643', 'cmplmnt_medio', 'cmplmnt_simple'].each do |cdg|
      txt = HTexto.find_by(codigo: cdg)
      @txts[cdg] = {}
      @txts[cdg][:h_texto] = txt.h_texto
      @txts[cdg][:texto] = txt.texto
    end
  end

  def encuesta
      @session_name = Digest::SHA1.hexdigest("#{session.id.to_s}#{Time.zone.today.to_s}")
      sesion = KSesion.find_by(sesion: @session_name)
      sesion = KSesion.create(sesion: @session_name) if sesion.blank?

#      @encuesta = KSesion.find_by(sesion: params[:sk])
      @encuesta = sesion
      @Pautas = Pauta.all.order(:orden)

      @pauta = ultima_pauta_contestada
      @cuestionarios = @pauta.blank? ? nil : @pauta.cuestionarios.order(:orden)

      @cuestionario = ultimo_cuestionario_contestado
      @preguntas = @cuestionario.blank? ? nil : @cuestionario.preguntas.order(:orden)

      @ultima_pregunta = ultima_pregunta_contestada

      @siguiente = ultima_respuesta.blank? ? primera_pregunta : siguiente_pregunta

      ur = ultima_respuesta
  end

  def preguntas
      @session_name = Digest::SHA1.hexdigest("#{session.id.to_s}#{Time.zone.today.to_s}")
      sesion = KSesion.find_by(sesion: @session_name)
      sesion = KSesion.create(sesion: @session_name) if sesion.blank?

#      @encuesta = KSesion.find_by(sesion: params[:sk])
      @encuesta = sesion
      @Pautas = Pauta.all.order(:orden)

      @pauta = ultima_pauta_contestada
      @cuestionarios = @pauta.blank? ? nil : @pauta.cuestionarios.order(:orden)

      @cuestionario = ultimo_cuestionario_contestado
      @preguntas = @cuestionario.blank? ? nil : @cuestionario.preguntas.order(:orden)

      @ultima_pregunta = ultima_pregunta_contestada

      @siguiente = ultima_respuesta.blank? ? primera_pregunta : siguiente_pregunta
  end

  private
    def ultima_pauta_contestada
      ultima_respuesta.blank? ? nil : ultima_respuesta.pregunta.cuestionario.pauta
    end

    def ultimo_cuestionario_contestado
      ur = ultima_respuesta
      ur.blank? ? nil : ur.pregunta.cuestionario
    end

    def ultima_pregunta_contestada
      ultima_respuesta.blank? ? nil : ultima_respuesta.pregunta
    end

    def primera_pauta
      Pauta.find_by(orden: 1)
    end

    def ultima_respuesta
      @encuesta.respuestas.last
    end

    def primer_cuestionario
      pauta = primera_pauta
      pauta.blank? ? nil : pauta.cuestionarios.order(:orden).first
    end

    def primera_pregunta
      pauta = primera_pauta
      cuestionario = pauta.blank? ? nil : pauta.cuestionarios.order(:orden).first
      cuestionario.blank? ? nil : cuestionario.preguntas.order(:orden).first
    end

    def siguiente_pregunta
      n_preg = @cuestionario.preguntas.count
      n_resp = @encuesta.respuestas.count
      cu = 
      if n_preg > n_resp
        @cuestionario.preguntas.find_by(orden: n_resp + 1)
      else
        @cuestionario = @pauta.cuestionarios.find_by(orden: @cuestionario.orden + 1)
        @cuestionario.blank? ? nil : @cuestionario.first
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_publico
      @objeto = Publico.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def publico_params
      params.fetch(:publico, {})
    end
end
