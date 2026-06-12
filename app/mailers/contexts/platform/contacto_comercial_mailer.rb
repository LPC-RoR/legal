# app/mailers/contexts/platform/contacto_comercial_mailer.rb
module Contexts
  module Platform
    class ContactoComercialMailer < ApplicationMailer
      def nueva_solicitud(requerimiento_id)
        @requerimiento = ComRequerimiento.find(requerimiento_id)
        
        mail(
          to: ENV.fetch('EQUIPO_COMERCIAL_EMAILS', 'hugo@laborsafe.cl'),
          subject: "Nueva solicitud de contacto comercial: #{@requerimiento.razon_social}"
        )
      end
    end
  end
end