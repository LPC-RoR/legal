# app/services/annm/anonimizador_txt.rb
module Annm
  # Pipeline independiente del origen y destino:
  #   origen (TxtEditable | ActArchivo con PDF) → anonimizar → TxtEditable destino
  #
  # Uso:
  #   Annm::AnonimizadorTxt.new(
  #     denuncia:        dnnc,
  #     origen:          txt_origen,            # TxtEditable o ActArchivo
  #     codigo_destino:  'txt_dclrcn_annmzd'
  #   ).ejecutar
  #
  # Si el TxtEditable destino ya existe, lo salta y lo devuelve sin tocarlo.
  class AnonimizadorTxt
    attr_reader :destino

    def initialize(denuncia:, codigo_destino:, origen: nil, ownr: nil)
      @denuncia       = denuncia
      @origen         = origen
      @ownr           = ownr || origen&.ownr
      @codigo_destino = codigo_destino
    end

    def ejecutar
      return existente if existente.present?   # ← salta si ya existe

      texto = texto_origen
      return nil if texto.blank?

      contenido_anon = AnonimizadorContenido.new(@denuncia).anonimizar(texto)

      @destino = @ownr.txt_editables.create!(
        codigo:     @codigo_destino,
        titulo:     titulo_destino,
        cntxt_clss: 'ClssTxtInvstgcns',
        contenido:  contenido_anon
      )
    end

    private

    def existente
      return nil if @ownr.blank?
      @existente ||= @ownr.txt_editables.find_by(codigo: @codigo_destino)
    end

    # ------------------------------------------------------------
    # ORIGEN: el texto se obtiene según el tipo de origen
    # ------------------------------------------------------------
    def texto_origen
      case @origen
      when TxtEditable
        # contenido es HTML: ReemplazadorHtml respeta las etiquetas
        @origen.contenido.to_s
      when ActArchivo
        texto_desde_pdf(@origen.pdf)
      when ActiveStorage::Attachment
        texto_desde_pdf(@origen)
      else
        nil
      end
    end

    # PDF: primero intenta extracción de texto; si la página no tiene
    # texto suficiente (PDF imagen/escaneado), cae a OCR
    def texto_desde_pdf(pdf)
      return "" unless pdf.attached?

      texto = ExtractorPdf.extract(pdf)
      return texto if texto.scan(/\p{L}{3,}/).size >= 5

      paginas = ExtractorPdfOcr.texto_por_pagina(pdf.blob)
      paginas.map { |p| p[:text] }.join("\n\n")
    end

    def titulo_destino
      ClssTxtInvstgcns.nombre[@codigo_destino] || "Documento anonimizado"
    end
  end
end