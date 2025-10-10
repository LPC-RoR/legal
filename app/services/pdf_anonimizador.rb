# app/services/pdf_anonimizador.rb
class PdfAnonimizador
  require 'pdf/reader'
  require 'prawn'
  require 'openai'

  OPENAI_CLIENT = OpenAI::Client.new(access_token: Rails.application.credentials.openai_api_key!)

  def initialize(blob)
    @blob = blob                 # ActiveStorage::Blob del PDF original
  end

  # Devuelve un IO (StringIO) con el PDF anonimizado
  def anonimizado_io
    texto_completo = extraer_texto
    texto_anonimizado = reemplazar_entidades(texto_completo)

    io = StringIO.new
    generar_pdf_desde_texto(texto_anonimizado, io)
    io.rewind
    io
  end

  private

  def extraer_texto
    texto = ''
    PDF::Reader.new(StringIO.new(@blob.download)).pages.each do |page|
      texto += page.text
    end
    texto
  end

  def reemplazar_entidades(texto)
    # Usamos OpenAI para NER; puedes cambiarlo por tu propio modelo
    prompt = <<~TXT
      Anonimiza el siguiente texto reemplazando:
      - Nombres de personas por [NOMBRE]
      - Direcciones por [DIRECCION]
      - Cargos/funciones por [CARGO]

      Texto:
      #{texto}
    TXT

    response = OPENAI_CLIENT.chat(
      parameters: {
        model: 'gpt-4',
        messages: [{ role: 'user', content: prompt }],
        temperature: 0
      }
    )

    response.dig('choices', 0, 'message', 'content') || texto
  end

  def generar_pdf_desde_texto(texto, io)
    Prawn::Document.new(page_size: 'A4', page_layout: :portrait) do |pdf|
      pdf.font_families.update('Helvetica' => {
                                 normal: 'Helvetica',
                                 bold: 'Helvetica-Bold'
                               })
      pdf.font 'Helvetica'
      pdf.text texto, size: 11, inline_format: true
    end.render(io)
  end
end