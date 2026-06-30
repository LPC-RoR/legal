# app/services/pdfs/context_pdf_service.rb
module Pdfs
  class ContextPdfService < BasePdfService
    # @param reporte [String] Identificador del reporte
    # @param opciones [Hash] Debe incluir :ownr (puede ser nil) y opcionalmente :objeto_id
    def self.generar_pdf(reporte, opciones = {})
      new(reporte, opciones).generar
    end
  end
end