# app/mailers/contexts/investigations/notification_mailer.rb
module Contexts
  module Investigations
    class NotificationMailer < ApplicationMailer
      def status_update(investigation, recipient)
        @investigation = investigation
        @recipient = recipient
        
        # @branding está disponible automáticamente:
        # - logo_url: logo de Empresa/Cliente o Laborsafe
        # - footer_html: footer de Empresa/Cliente o default
        # - brand_name: nombre de Empresa/Cliente o "Laborsafe"
        
        mail to: recipient.email, subject: default_i18n_subject
      end
    end
  end
end