# app/jobs/mailers/delivery_job.rb
class Mailers::DeliveryJob < ApplicationJob
  queue_as :mailers
  
  # UN solo job para todos los contextos
  def perform(mailer_class, action, tenant_id, recipient_ids, params = {})
    ActsAsTenant.with_tenant(Tenant.find(tenant_id)) do
      mailer = mailer_class.constantize.with(params)
      
      recipient_ids.each do |recipient_id|
        recipient = resolve_recipient(recipient_id)
        next unless recipient&.email.present?
        
        email = mailer.public_send(action, recipient)
        email.deliver_now
        
        log_delivery(email, recipient, mailer_class, action)
      rescue => e
        handle_delivery_error(e, mailer_class, action, recipient_id)
      end
    end
  end
  
  private
  
  def resolve_recipient(id_or_hash)
    case id_or_hash
    when Hash then GlobalID::Locator.locate(id_or_hash['gid'])
    else User.find_by(id: id_or_hash)
    end
  end
  
  def log_delivery(email, recipient, mailer_class, action)
    EmailDeliveryLog.create!(
      tenant: ActsAsTenant.current_tenant,
      recipient: recipient,
      mailer_class: mailer_class,
      mailer_action: action,
      subject: email.subject,
      sent_at: Time.current,
      message_id: email.message_id
    )
  end
end

# Uso desde cualquier contexto:
Mailers::DeliveryJob.perform_later(
  'Contexts::Platform::AccountMailer',
  :payment_failed,
  current_tenant.id,
  [account_owner.id],
  { invoice_id: invoice.id }
)