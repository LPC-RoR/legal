# app/services/mailers/investigations/pdf_template_resolver.rb
module Mailers
  module Investigations
    class PdfTemplateResolver
      TEMPLATES = {
        dnncnt_info_oblgtr: 'mailers/investigations/document/dnncnt_info_oblgtr',
        resumen_ejecutivo: 'mailers/investigations/document/resumen_ejecutivo_pdf',
        acta_audiencia: 'mailers/investigations/document/acta_audiencia_pdf',
        notificacion_participante: 'mailers/investigations/document/notificacion_pdf'
      }.freeze

      def self.resolve(template_key, investigation)
        new(template_key, investigation).resolve
      end

      def initialize(template_key, investigation)
        @template_key = template_key.to_sym
        @investigation = investigation
      end

      def resolve
        {
          template_path: template_path,
          custom_assigns: template_assigns,
          pdf_options: specific_pdf_options
        }
      end

      private

      def template_path
        TEMPLATES[@template_key] || default_template
      end

      def default_template
        'mailers/investigations/document/generic_pdf'
      end

      def template_assigns
        case @template_key
        when :informe_cierre
          {
            conclusiones: @investigation.conclusiones,
            recomendaciones: @investigation.recomendaciones,
            fecha_cierre: Time.current
          }
        when :acta_audiencia
          {
            participantes_presentes: @investigation.audiencia_participantes,
            fecha_audiencia: @investigation.fecha_audiencia,
            hechos_confirmados: @investigation.hechos_confirmados
          }
        else
          {}
        end
      end

      def specific_pdf_options
        case @template_key
        when :acta_audiencia
          { margin: { top: '30mm', bottom: '30mm' } } # Márgenes amplios para firmas
        else
          {}
        end
      end
    end
  end
end