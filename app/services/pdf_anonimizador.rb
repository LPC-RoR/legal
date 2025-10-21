# app/services/pdf_anonimizador.rb
class PdfAnonimizador
  require 'prawn'
  require 'prawn/markup'
  require 'openai'
  require 'redcarpet'

  MODEL = 'gpt-4o'

  def initialize(blob)
    @blob = blob
  end

  # Devuelve StringIO con PDF anonimizado
  def anonimizado_io
    # 1. Texto con formato (OCR sobre imágenes)
    paginas = PdfImageTextExtractor.texto_por_pagina(@blob)

    # 2. Unir páginas
    texto_completo = paginas.map { |p| p[:text] }.join("\n").presence || '[sin texto]'

    # 3. Anonimizar y devolver Markdown
    md_anonimizado = anonimiza_con_markdown(texto_completo)
    html_anonimizado = markdown_to_html(md_anonimizado)

    # 4. PDF desde Markdown
    io = StringIO.new
    generar_pdf_desde_html(html_anonimizado, io)
    io.rewind
    io
  end

  private

  # GPT devuelve Markdown (conserva viñetas, negritas, saltos)
  def anonimiza_con_markdown(texto)
    prompt = <<~TXT
      Anonimiza únicamente los datos sensibles y **devuelve el texto en Markdown puro** (sin bloques ```).
      Conserva:
      - viñetas (- ó •)
      - negritas (**texto**)
      - saltos de párrafo (\n\n)
      - títulos (# ##)
      Sustituciones:
      - Nombres → [NOMBRE]
      - Cargos → [CARGO]
      - RUT/DNI → [RUT/CI]
      - Emails → [EMAIL]
      - Teléfonos → [TELEFONO]
      - Direcciones → [DIRECCIÓN]

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
    # asegura espacio tras tag
    raw.gsub(/\[(NOMBRE|CARGO|RUT\/CI|EMAIL|TELEFONO|DIRECCIÓN)\](?!\s)/, '[\1] ')
  end

  def generar_pdf_desde_html(html, io)
    Prawn::Document.new(page_size: 'A4', page_layout: :portrait) do |pdf|
      pdf.font 'Helvetica'
      pdf.extend Prawn::Markup
      pdf.markup html
    end.render(io)
  end

  def markdown_to_html(md)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(md)
  end

end