# app/mailers/contexts/platform/base_mailer.rb
module Contexts
  module Investigations
    class BaseMailer < ApplicationMailer
      # Hereda de ApplicationMailer, usa layout 'mailers/base'
      # Branding: AppConfiguration (owner) o Laborsafe fallback
    end
  end
end