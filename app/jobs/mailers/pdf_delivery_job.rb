module Mailers
  class PdfDeliveryJob < ApplicationJob
    queue_as :pdf_generation
    
    retry_on StandardError, wait: :polynomially_longer, attempts: 3

    def perform(context, mailer_type, record_gid, recipient_gid, options)
      Rails.logger.debug "=== JOB START ==="
      Rails.logger.debug "Raw args: context=#{context.inspect}, mailer_type=#{mailer_type.inspect}, record_gid=#{record_gid.inspect}, recipient_gid=#{recipient_gid.inspect}, options=#{options.inspect}"
      
      record = GlobalID::Locator.locate(record_gid)
      recipient = recipient_gid.present? ? GlobalID::Locator.locate(recipient_gid) : nil
      
      Rails.logger.debug "Located: record=#{record.inspect}, recipient=#{recipient.inspect}"
      
      # Establecer tenant si el record lo tiene
      if record.respond_to?(:tenant) && record.tenant.present?
        ActsAsTenant.with_tenant(record.tenant) do
          execute_delivery(context.to_sym, mailer_type.to_sym, record, recipient, options)
        end
      else
        execute_delivery(context.to_sym, mailer_type.to_sym, record, recipient, options)
      end
    end

    private

    def execute_delivery(context, mailer_type, record, recipient, options)
    
      service = Mailers::PdfDeliveryService.new(
        context,
        mailer_type,
        record,
        recipient,
        options
      )
      
      Rails.logger.debug "Service created, calling deliver_now..."
      service.deliver_now
    end
  end
end