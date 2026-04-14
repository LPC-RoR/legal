# app/mailers/contexts/investigations/document_mailer.rb
module Contexts
  module Investigations
    class DocumentMailer < BaseMailer
      default from: 'no-reply@laborsafe.cl'

  #    def notification_with_pdf(investigation, recipient, pdf_data, filename, options = {})
  #      @investigation = investigation
  #      @recipient = recipient
  #      @custom_data = options[:custom_data] || {}

  #      attachments[filename] = {
  #        mime_type: 'application/pdf',
  #        content: pdf_data
  #      }

  #      mail(
  #        to: recipient.email,
  #        subject: options[:subject] || default_i18n_subject
  #      )
  #    end

      def dnncnt_info_oblgtr(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "info_obligatoria_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      def comprobante(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      def invstgcn(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      def drchs(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      def medidas_resguardo(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      def txt_mdds_rsgrd(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      def invstgdr(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      def dclrcn(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      def crdncn_apt(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end
      def infrmcn(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      def drvcn(investigation, recipient, pdf_data = nil, options = {})
        setup_and_send_email(
          investigation, 
          recipient, 
          pdf_data, 
          options,
          default_filename: "comprobante_#{investigation.id}_#{Time.current.strftime('%Y%m%d')}.pdf"
        )
      end

      private

      def setup_and_send_email(investigation, recipient, pdf_data, options, default_filename:)
        # 1. Asignar variables de instancia
        assign_instance_variables(investigation, recipient, options)

        # 2. Configurar URL options y head/sign URLs
        set_url_options_for_emprs(@emprs)

        # 3. Adjuntar PDF si existe
        attach_pdf_if_present(pdf_data, options, default_filename)

        # 4. Enviar email
        send_email(recipient, options, investigation)
      end

      def assign_instance_variables(investigation, recipient, options)
        @objeto       = investigation
        @recipient    = recipient
        @emprs        = investigation.ownr
        @custom_data  = options[:custom_data] || {}
        @options      = options
        @ntfcdr       = options[:ntfcdr]

        emprs_logo  = @objeto&.ownr&.logo&.url
        emprs_sign  = @objeto&.ownr&.sign&.url
        @head_url   = emprs_logo ? emprs_logo : "#{root_url}mssgs/email_head.png"
        @sign_url   = emprs_logo ? emprs_sign : "#{root_url}mssgs/email_sign.png"
      end

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

      def attach_pdf_if_present(pdf_data, options, default_filename)
        return if pdf_data.blank?

        filename = options[:filename] || default_filename
        attachments[filename] = {
          mime_type: 'application/pdf',
          content: pdf_data
        }
      end

      def send_email(recipient, options, investigation)
        mail(
          to: recipient.email,
          subject: options[:subject] || t('.subject', id: investigation.id)
        )
      end

    end
  end
end