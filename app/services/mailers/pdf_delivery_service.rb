# app/services/mailers/pdf_delivery_service.rb

## El parámetro record recive un objeto que se nombró objeto, ambos nombres tienen el mismo nivel de generalidad

module Mailers
  class PdfDeliveryService
    def initialize(context, mailer_type, record, recipient, options = {})
      @context = context.to_sym
      @mailer_type = mailer_type.to_sym
      @record = record
      @recipient = recipient
      @options = options.deep_symbolize_keys
    end

    def deliver_now
      ## NO es necesario volver a crear el archivo ActArchivo, porque ya se creo y se pasó dentro de @options
#      pdf_data = generate_pdf
      send_email_with_attachment(@options[:pdf_data])
    end

    def deliver_later
      Mailers::PdfDeliveryJob.perform_later(
        @context,
        @mailer_type,
        @record.to_global_id.to_s,
        @recipient&.to_global_id&.to_s,
        @options
      )
    end

    private

    def render_pdf_template
      template_path = @options[:pdf_template] || default_pdf_template
      layout_path = @options[:pdf_layout] || default_pdf_layout
      
      ApplicationController.render(
        template: template_path,
        layout: layout_path,
        assigns: template_assigns
      )
    end

    def template_assigns
      {
        record: @record,
        recipient: @recipient,
        context: @context,
        options: @options,
        recipient_name: recipient_display_name,
        recipient_email: recipient_display_email
      }
    end

    def recipient_display_name
      return 'Destinatario' if @recipient.nil?
      
      @recipient.try(:nombre) || 
      @recipient.try(:nombre_completo) || 
      @recipient.try(:razon_social) || 
      @recipient.try(:email) || 
      'Destinatario'
    end

    def recipient_display_email
      return '' if @recipient.nil?
      @recipient.try(:email) || ''
    end

    def send_email_with_attachment(pdf_data)
      mailer_class = resolve_mailer_class
      
      email_options = @options.merge(filename: filename)
      
      mailer_class.public_send(
        mailer_action,
        @record,
        @recipient,
        pdf_data,
        email_options
      ).deliver_now
    end

    def resolve_mailer_class
      # Usa camelize en lugar de classify para mantener el plural
      "Contexts::#{@context.to_s.camelize}::#{@mailer_type.to_s.camelize}Mailer".constantize
    rescue NameError
      raise UnknownMailerError, "No existe mailer para contexto #{@context}, tipo #{@mailer_type}"
    end

    def mailer_action
      @options[:mailer_action] || :notification_with_pdf
    end

    def filename
      base = @options[:filename] || "#{@context}_#{@record.id}"
      timestamp = Time.current.strftime('%Y%m%d_%H%M%S')
      "#{base}_#{timestamp}.pdf"
    end

    def default_pdf_template
      "contexts/#{@context}/#{@mailer_type}_mailer/#{mailer_action}"
    end

    def default_pdf_layout
      'mailers/pdf/base'
    end
  end
  
  class UnknownMailerError < StandardError; end
end