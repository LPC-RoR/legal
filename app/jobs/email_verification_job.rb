# app/jobs/email_verification_job.rb
class EmailVerificationJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    Rails.logger.error "EmailVerificationJob Failed: #{exception.message}"
    retry_job(wait: 5.minutes) if exception.is_a?(Net::SMTPError)
  end

  # Llama así: EmailVerificationJob.perform_later("User", user.id, verification_url, Current.tenant_id)
  def perform(model_class, model_id, verification_url, tenant_id = nil)
    # (Opcional) restaura tenant si usas multitenencia/Current
    Current.tenant = Tenant.find(tenant_id) if tenant_id

    # No cargamos el registro aquí: se resuelve en el mailer (unscoped).
    VrfccnMailer.with(
      user_class:       model_class,      # "User"
      user_id:          model_id,         # 123
      verification_url: verification_url, # string
      tenant_id:        tenant_id         # nil o id
    ).verification_email.deliver_now
  ensure
    Current.reset_all if Current.respond_to?(:reset_all)
  end
end
