# config/initializers/openai.rb
OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai_api_key!
  config.request_timeout = 180
end