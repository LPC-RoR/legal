# app/mailers/contexts/investigations/document_mailer.rb
module Contexts
  module Investigations
    class DocumentMailer < BaseMailer
      default from: 'no-reply@laborsafe.cl'

      def notification_with_pdf(investigation, recipient, pdf_data, filename, options = {})
        @investigation = investigation
        @recipient = recipient
        @custom_data = options[:custom_data] || {}

        attachments[filename] = {
          mime_type: 'application/pdf',
          content: pdf_data
        }

        mail(
          to: recipient.email,
          subject: options[:subject] || default_i18n_subject
        )
      end

      def dnncnt_info_oblgtr(investigation, recipient, pdf_data = nil, options = {})
        # 1. Primero asignar variables
        @objeto       = investigation
        @recipient    = recipient
        @emprs        = investigation.ownr
        @custom_data  = options[:custom_data] || {}
        @options      = options

        # 2. Configurar URL options ANTES de usar url_for o asset_url
        set_url_options_for_emprs(@emprs)

        # 3. Ahora sí usar url_for con el host configurado

        emprs_logo  = @objeto&.ownr&.logo&.url
        emprs_sign  = @objeto&.ownr&.sign&.url
        @head_url   = emprs_logo ? emprs_logo : "#{root_url}mssgs/email_head.png"
        @sign_url   = emprs_logo ? emprs_sign : "#{root_url}mssgs/email_sign.png"

        # 4. Adjuntar PDF si existe
        if pdf_data.present?
          filename = options[:filename] || "info_obligatoria_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
          attachments[filename] = {
            mime_type: 'application/pdf',
            content: pdf_data
          }
        end

        # 5. Enviar email
        mail(
          to: recipient.email,
          subject: options[:subject] || t('.subject', id: investigation.id)
        )
      end

      private

      def set_url_options_for_emprs(emprs)
        host      = Rails.env.production? ? 'www.laborsafe.cl' : 'localhost:3000'
        protocol  = Rails.env.production? ? 'https' : 'http'
        
        # Configura para este mailer específico
        @host = host
        @protocol = protocol
        
        # O usa default_url_options a nivel de instancia
        default_url_options[:host] = host
        default_url_options[:protocol] = protocol
      end
    end
  end
end