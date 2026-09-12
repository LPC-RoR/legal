module Comercial
  class LeadMailer < ApplicationMailer
    def nuevo_lead
      @lead = params[:lead]

      mail(
        to: Rails.application.config.lead_notification_recipients,
        subject: "Nuevo lead: #{@lead.nombre} (#{@lead.fuente})"
      )
    end

    # Copia de la simulación enviada al propio lead
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