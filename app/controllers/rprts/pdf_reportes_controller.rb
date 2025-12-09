module Rprts
  class PdfReportesController < ApplicationController
    before_action :autorizar_registro, :cargar_registro

    def generar
      # Procesamiento asíncrono
      ::PdfGenerationJob.perform_later(
        @modelo.name,
        params[:id],
        params[:tipo]
      )
      
      redirect_to ruta_referencia,
                  notice: "📄 Generación de PDF en proceso. Recargue en unos segundos."
    rescue StandardError => e
      Rails.logger.error "PDF Error #{params[:modelo]}##{params[:id]}: #{e.message}"
      redirect_back fallback_location: root_path,
                    alert: "❌ Error al iniciar generación de PDF."
    end

    def descargar
      archivo = @registro.act_archivo
      
      if archivo&.pdf&.attached?
        redirect_to rails_blob_path(archivo.pdf, disposition: 'attachment')
      else
        redirect_to ruta_referencia,
                    alert: "📄 PDF no disponible. Genere el reporte primero."
      end
    end

    private

    def cargar_registro
      @modelo = params[:modelo].classify.constantize
      @registro = @modelo.find(params[:id])
    end

    def ruta_referencia
      # Genera automáticamente la ruta del modelo
      send("#{params[:modelo]}_path", @registro)
    rescue StandardError
      @registro
    end

    def autorizar_registro
      # Implementa Pundit/Cancancan
      # authorize @registro, :show?
    end
  end
end