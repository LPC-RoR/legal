module Comercial
  class LeadMailer < ApplicationMailer
    CORREO_VENTAS = 'ventas@laborsafe.cl'.freeze

    # Aviso interno: cada vez que se crea un lead (existente, sin cambios)
    def nuevo_lead
      @lead = params[:lead]

      mail(
        to: Rails.application.config.lead_notification_recipients,
        subject: "Nuevo lead: #{@lead.nombre} (#{@lead.fuente})"
      )
    end

    # ACCIÓN 1 (inmediata): resultado de la autoevaluación al propio lead
    def resultado_diagnostico
      @lead = params[:lead]

      mail(
        to: @lead.email,
        subject: "Su autodiagnóstico Ley 21.643 – resultados y próximos pasos"
      )
    end

    # ACCIÓN 2 (solo si el lead envió pregunta): derivación a ventas
    def nueva_pregunta
      @lead = params[:lead]

      mail(
        to: CORREO_VENTAS,
        reply_to: @lead.email,
        subject: "Pregunta de #{@lead.nombre} – responder dentro de 1 día hábil"
      )
    end

    # Copia de la simulación enviada al propio lead (existente, sin cambios)
    def copia_simulacion
      @lead       = params[:lead]
      @fecha_base = params[:fecha_base]
      @plazos     = params[:plazos]
      @total_dias = params[:total_dias]

      mail(
        to: @lead.email,
        subject: "Tu simulación de plazos – Denuncia recibida el #{l(@fecha_base, format: '%d/%m/%Y')}"
      )
    end
  end
end