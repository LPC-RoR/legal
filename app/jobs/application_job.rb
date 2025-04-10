class ApplicationJob < ActiveJob::Base
  rescue_from ActiveJob::DeserializationError do |exception|
    Rails.logger.error "Error deserializing job: #{exception.message}"
  end
end
