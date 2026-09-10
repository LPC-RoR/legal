module Comercial
  class LeadMailer < ApplicationMailer
    def nuevo_lead
      @lead = params[:lead]

      mail(
        to: Rails.application.config.lead_notification_recipients,
        subject: "Nuevo lead: #{@lead.nombre} (#{@lead.fuente})"
      )
    end
  end
end