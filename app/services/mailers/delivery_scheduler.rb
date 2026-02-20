# app/services/mailers/delivery_scheduler.rb
class Mailers::DeliveryScheduler
  def self.schedule(context, mailer_type, action, recipients, params = {})
    mailer_class = resolve_mailer(context, mailer_type)
    
    Mailers::DeliveryJob.perform_later(
      mailer_class.name,
      action,
      ActsAsTenant.current_tenant.id,
      recipients.map { |r| r.to_global_id.to_s },
      params
    )
  end
  
  def self.schedule_bulk(context, mailer_type, action, recipient_scope, params = {})
    # Para envíos masivos, divide en batches
    recipient_scope.find_in_batches(batch_size: 100) do |batch|
      Mailers::BatchDeliveryJob.perform_later(
        context, mailer_type, action, 
        batch.map(&:id), params
      )
    end
  end
  
  private
  
  def self.resolve_mailer(context, type)
    "Contexts::#{context.to_s.classify}::#{type.to_s.classify}Mailer".constantize
  rescue NameError
    raise UnknownMailerError, "No existe mailer para contexto #{context}, tipo #{type}"
  end
end

# Uso simplificado en toda la app:
Mailers::DeliveryScheduler.schedule(
  :platform,           # context
  :account,            # mailer type
  :welcome,            # action
  [new_admin],         # recipients
  { account_id: account.id }
)

# O para soporte:
Mailers::DeliveryScheduler.schedule(
  :support,
  :ticket,
  :created,
  [ticket.requester, ticket.assigned_agent].compact,
  { ticket_id: ticket.id }
)