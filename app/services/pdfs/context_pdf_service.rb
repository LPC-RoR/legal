# app/services/pdfs/context_pdf_service.rb
module Pdfs
  class ContextPdfService < BasePdfService
    def self.generar_pdf(reporte, opciones = {})
      new(reporte, opciones).generar
    end

    # Genera el contenido binario del PDF sin pasar por almacenar!
    # Útil para anonimización donde no queremos ActArchivo intermedios.
    def self.generar_pdf_contenido(reporte, opciones = {})
      servicio = new(reporte, opciones)
      servicio.send(:cargar_datos!)
      servicio.send(:cargar_assets!)
      html = servicio.send(:generar_html!)
      html = servicio.send(:inlinear_css_externo, html)
      servicio.send(:generar_pdf!, html)
    end

    def initialize(reporte, opciones = {})
      super
      @act_original = opciones[:act_original]
      @anonimizar   = opciones[:anonimizar].present?
      @datos_anon   = opciones[:participante_anonimizado] || {}
      @todos_participantes = opciones[:todos_participantes] || []
    end

    # ------------------------------------------------------------------
    # Helpers para templates (accesibles via @pdf en la vista)
    # ------------------------------------------------------------------

    def nombre_para(participante)
      @anonimizar ? '[NOMBRE]' : participante.try(:nombre)
    end

    def cargo_para(participante)
      @anonimizar ? '[CARGO]' : participante.try(:cargo)
    end

    def profesion_para(participante)
      @anonimizar ? '[PROFESION]' : participante.try(:profesion)
    end

    # Reemplazos simples sobre texto plano.
    # Para txt_mdds_rsgrd y similares se prefiere ahora la copia manual
    # del TxtEditable (@act.txt_anonimizado.contenido).
    def procesar_texto(texto)
      return texto unless @anonimizar && texto.present?

      @todos_participantes.each do |p|
        texto = texto.gsub(/#{Regexp.escape(p[:nombre])}/i,    '[NOMBRE]')    if p[:nombre].present?
        texto = texto.gsub(/#{Regexp.escape(p[:cargo])}/i,     '[CARGO]')     if p[:cargo].present?
        texto = texto.gsub(/#{Regexp.escape(p[:profesion])}/i, '[PROFESION]') if p[:profesion].present?
      end

      texto = texto.gsub(/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/, '[EMAIL]')
      texto
    end

    private

    def preparar_assigns
      super.merge(
        act:            @act_original,
        es_anonimizado: @anonimizar,
        pdf:            self
      )
    end

    # Descarga CSS de links externos y los inyecta como <style> inline.
    # Elimina el link si no puede descargarse, para evitar que Ferrum
    # se cuelgue con PendingConnectionsError.
    def inlinear_css_externo(html)
      require 'nokogiri'
      require 'net/http'
      require 'uri'

      doc = Nokogiri::HTML(html)

      doc.css('link[rel="stylesheet"]').each do |link|
        href = link['href'].to_s.strip
        next unless href.start_with?('http://', 'https://')

        begin
          uri = URI(href)
          response = Net::HTTP.get_response(uri)

          if response.is_a?(Net::HTTPRedirection)
            response = Net::HTTP.get_response(URI(response['location']))
          end

          css = response.body.to_s

          if response.is_a?(Net::HTTPSuccess) && css.length > 1000
            style = Nokogiri::XML::Node.new('style', doc)
            style.content = css
            link.replace(style)
          else
            Rails.logger.warn "[ContextPdfService] CSS inválido o vacío: #{href}"
            link.remove
          end
        rescue => e
          Rails.logger.warn "[ContextPdfService] No se pudo descargar CSS #{href}: #{e.message}"
          link.remove
        end
      end

      doc.to_html
    end
  end
end