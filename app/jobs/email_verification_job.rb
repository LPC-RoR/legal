# app/jobs/email_verification_job.rb
class EmailVerificationJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    Rails.logger.error "EmailVerificationJob Failed: #{exception.message}"
    retry_job(wait: 5.minutes) if exception.is_a?(Net::SMTPError)
  end

  def perform(model_class, model_id)
    VrfccnMailer.verification_email(model_class, model_id).deliver_now
  end
end