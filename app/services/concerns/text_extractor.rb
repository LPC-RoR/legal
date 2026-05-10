# app/services/concerns/text_extractor.rb
module TextExtractor
  extend ActiveSupport::Concern

  # Extrae texto plano desde ActionText (KrnTexto#contenido)
  def extraer_texto_plano(krn_texto)
    return nil if krn_texto.nil? || krn_texto.contenido.blank?

    # ActionText::RichText tiene #to_plain_text que extrae el texto sin HTML
    texto = krn_texto.contenido.to_plain_text
    
    # Normaliza espacios y codificación
    texto = texto.gsub(/\s+/, ' ').strip
    texto.unicode_normalize(:nfc)
  end
end