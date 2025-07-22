class Aplicacion::PublicosController < ApplicationController
  before_action :authenticate_usuario!, only: %i[ encuesta preguntas ]
  before_action :scrty_on, only: %i[ home home_prueba encuesta preguntas ]
  before_action :inicia_sesion, only: [:home]
#  before_action :check_user_confirmation, if: :user_signed_in?
  # GET /publicos or /publicos.json
  def index
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

    # Only allow a list of trusted parameters through.
    def publico_params
      params.fetch(:publico, {})
    end
end
