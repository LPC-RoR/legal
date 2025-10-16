# app/services/pdf_anonimizador.rb
class PdfAnonimizador
  require 'pdf/reader'
  require 'prawn'
  require 'openai'
  require 'mini_magick'
  require 'rtesseract'

  TOKEN_LIMIT   = 50_000
  OVERLAP_CHARS = 2_000
  MODEL         = 'gpt-4o'

  def initialize(blob)
    @blob = blob
  end

  # app/services/pdf_anonimizador.rb  (fragmento clave)
  def anonimizado_io
    # 1.  texto de cada página (OCR si hace falta)
    paginas = PdfOcrReader.texto_por_pagina(@blob)

    # 2.  texto de las imágenes incrustadas
    imgs_por_pag = PdfImageTextExtractor.textos_por_pagina(@blob)

    # 3.  ensamblar cuerpo
    texto_completo = paginas.map do |p|
      base = p[:text]
      if (imgs = imgs_por_pag[p[:page]])
        imgs.each { |img| base += "\n[IMAGEN-#{p[:page]}-#{img[:idx]}]\n#{img[:text]}\n[IMAGEN-#{p[:page]}-#{img[:idx]}]\n" }
      end
      base
    end.join("\n")

    # 3b.  garantía: nunca envíes cadena vacía a GPT
    texto_completo = texto_completo.presence || '[sin texto]'

    # 4.  anonimizar con GPT-4o
    texto_anonimizado = anonimiza_con_gpt(texto_completo)

    # 5.  PDF limpio
    io = StringIO.new
    generar_pdf_desde_texto(texto_anonimizado, io)
    io.rewind
    io
  end

  private

  def anonimiza_con_gpt(texto)
    prompt = <<~TXT
      Anonimiza el siguiente texto.
      Reemplaza:
      - Nombres de personas → [NOMBRE]
      - Cargos → [CARGO]
      - Emails → [EMAIL]
      - Teléfonos → [TELEFONO]
      - RUT/DNI → [RUT/CI]
      - Direcciones postales → solo hasta el número (calle+número), deja la comuna/ciudad/region sin cambio.
      - Deja intactos los marcadores [IMAGEN-X]

      Ejemplos de salida esperada:
      ENTRADA:  DOMICILIO : Gálvez Nº 1569 27 Comuna de Isla de Maipo
      SALIDA:   DOMICILIO : [DIRECCION]

      ENTRADA:  Avda. Providencia N° 1208, Of. 207, Providencia
      SALIDA:   [DIRECCION]

      Texto:
      #{texto}
    TXT

    response = OpenAI::Client.new.chat(
      parameters: {
        model: MODEL,
        messages: [{ role: 'user', content: prompt }],
        temperature: 0
      }
    )
    response.dig('choices', 0, 'message', 'content') || texto
  end

  def generar_pdf_desde_texto(texto, io)
    Prawn::Fonts::AFM.hide_m17n_warning = true
    Prawn::Document.new(page_size: 'A4', page_layout: :portrait) do |pdf|
      pdf.font 'Helvetica'
      pdf.text texto, size: 11, inline_format: true
    end.render(io)
  end
end