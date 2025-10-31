# app/models/act_texto.rb
class ActTexto < ApplicationRecord
  belongs_to :act_archivo
  
  # Tipos de documentos que pueden generarse
  TIPOS_DOCUMENTO = {
    lista_participantes: 'Lista de Participantes',
    resumen_anonimizado: 'Resumen Anonimizado',
    lista_hechos: 'Lista de Hechos'
  }.freeze

  validates :tipo_documento, inclusion: { in: TIPOS_DOCUMENTO.keys.map(&:to_s) }
  validates :titulo, presence: true
  
  has_rich_text :contenido
  has_one_attached :archivo_exportado

  before_save :limpiar_html_si_es_necesario

  scope :por_tipo, ->(tipo) { where(tipo_documento: tipo) }
  scope :lista_participantes, -> { por_tipo('lista_participantes') }
  scope :resumen_anonimizado, -> { por_tipo('resumen_anonimizado') }
  scope :lista_hechos, -> { por_tipo('lista_hechos') }

  def nombre_tipo
    TIPOS_DOCUMENTO[tipo_documento.to_sym]
  end

  def puede_editarse?
    %w[lista_participantes resumen_anonimizado lista_hechos].include?(tipo_documento)
  end

  def exportar_a_pdf!
    html_content = preparar_html_para_pdf
    pdf = generar_pdf_desde_html(html_content)
    
    archivo_exportado.purge if archivo_exportado.attached?
    archivo_exportado.attach(
      io: StringIO.new(pdf),
      filename: "#{titulo.parameterize}.pdf",
      content_type: 'application/pdf'
    )
  end

  def exportar_a_word!
    html_content = preparar_html_para_word
    docx = generar_docx_desde_html(html_content)
    
    archivo_exportado.purge if archivo_exportado.attached?
    archivo_exportado.attach(
      io: StringIO.new(docx),
      filename: "#{titulo.parameterize}.docx",
      content_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    )
  end

  private

  def limpiar_html_si_es_necesario
    # ActionText ya maneja el HTML, pero podemos agregar validaciones adicionales
    true
  end

  def preparar_html_para_pdf
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            h1 { color: #333; border-bottom: 2px solid #333; }
            h2 { color: #666; margin-top: 20px; }
            p { line-height: 1.6; margin: 10px 0; }
            .fecha { font-weight: bold; color: #0066cc; }
            .identificador { background-color: #f0f0f0; padding: 2px 4px; border-radius: 3px; }
          </style>
        </head>
        <body>
          #{contenido.to_s}
        </body>
      </html>
    HTML
  end

  def preparar_html_para_word
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <style>
            body { font-family: 'Times New Roman', serif; margin: 20px; }
            h1 { color: #000; font-size: 18pt; }
            h2 { color: #000; font-size: 14pt; margin-top: 20px; }
            p { line-height: 1.5; margin: 10px 0; font-size: 12pt; }
          </style>
        </head>
        <body>
          #{contenido.to_s}
        </body>
      </html>
    HTML
  end

  def generar_pdf_desde_html(html)
    # Usaremos wicked_pdf o similar
    WickedPdf.new.pdf_from_string(html)
  end

  def generar_docx_desde_html(html)
    # Usaremos htmltoword o similar
    Htmltoword::Document.create(html, "#{titulo.parameterize}.docx")
  end
end