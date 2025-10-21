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

  # ------------------------------------------------------------------
  # Devuelve un StringIO con el PDF anonimizado
  # ------------------------------------------------------------------
  def anonimizado_io
    # 1. Texto de cada página (OCR sobre imágenes -> conserva espacios)
    paginas = PdfImageTextExtractor.texto_por_pagina(@blob)

    # 2. Texto de las imágenes incrustadas (si las hay)
#    imgs_por_pag = PdfImageTextExtractor.textos_por_pagina(@blob)

    # 3. Ensamblar cuerpo
    texto_completo = paginas.map do |p|
      base = p[:text]
#      if (imgs = imgs_por_pag[p[:page]])
#        imgs.each { |img| base += "\n[IMAGEN-#{p[:page]}-#{img[:idx]}]\n#{img[:text]}\n[IMAGEN-#{p[:page]}-#{img[:idx]}]\n" }
#      end
      base
    end.join("\n")

    texto_completo = texto_completo.presence || '[sin texto]'

    # 4. Anonimizar con GPT-4o
    texto_anonimizado = anonimiza_manteniendo_formato(texto_completo)

    # 5. Generar PDF limpio
    io = StringIO.new
    generar_pdf_desde_texto(texto_anonimizado, io)
    io.rewind
    io
  end

  private

  # ------------------------------------------------------------------
  # GPT anonimiza *sin* tocar espacios ni saltos
  # ------------------------------------------------------------------
  def anonimiza_manteniendo_formato(texto)
    prompt = <<~TXT
      Actúa como anonimizador legal.
      Reemplaza únicamente los datos sensibles indicados.
      DEBES conservar **cada espacio y salto de línea** exactamente como aparece.
      NO añadas ni elimines ningún carácter que no sea el dato a reemplazar.

      Sustituciones:
      - Nombres de personas → [NOMBRE]
      - Cargos → [CARGO]
      - RUT/DNI → [RUT/CI]
      - Emails → [EMAIL]
      - Teléfonos → [TELEFONO]
      - Direcciones (calle+número) → [DIRECCIÓN]

      Texto a anonimizar:
      #{texto}
    TXT

    response = OpenAI::Client.new.chat(
      parameters: {
        model: MODEL,
        messages: [{ role: 'user', content: prompt }],
        temperature: 0
      }
    )
    raw = response.dig('choices', 0, 'message', 'content') || texto

    # restaura espacio tras tag si GPT lo olvida
    raw.gsub!(/\[(NOMBRE|CARGO|RUT\/CI|EMAIL|TELEFONO|DIRECCIÓN)\](?!\s)/, '[\1] ')
    raw
  end

  # ------------------------------------------------------------------
  # PDF desde texto plano (respeta saltos)
  # ------------------------------------------------------------------
  def generar_pdf_desde_texto(texto, io)
    Prawn::Fonts::AFM.hide_m17n_warning = true
    Prawn::Document.new(page_size: 'A4', page_layout: :portrait) do |pdf|
      pdf.font 'Helvetica'
      pdf.text texto, size: 11
    end.render(io)
  end
end