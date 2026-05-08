# app/services/concerns/pdf_extractor.rb
module PdfExtractor
  extend ActiveSupport::Concern

  def extraer_texto_pdf(archivo)
    return nil unless archivo.pdf.attached?

    texto = extraer_con_pdftotext(archivo) || extraer_con_pdf_reader(archivo)
    texto&.unicode_normalize(:nfc)
  rescue => e
    Rails.logger.error "[PdfExtractor] Error: #{e.message}"
    nil
  end

  private

  def extraer_con_pdftotext(archivo)
    require 'tempfile'

    pdf_temp = Tempfile.new(['doc', '.pdf'])
    pdf_temp.binmode
    pdf_temp.write(archivo.pdf.download)
    pdf_temp.close

    txt_temp = Tempfile.new(['doc', '.txt'])

    # -layout: preserva layout, -nopgbrk: sin saltos de página, -enc UTF-8: codificación
    system("pdftotext -layout -nopgbrk -enc UTF-8 #{pdf_temp.path} #{txt_temp.path} 2>/dev/null")

    return nil unless File.exist?(txt_temp.path) && File.size(txt_temp.path) > 0

    File.read(txt_temp.path, encoding: 'UTF-8')
  ensure
    pdf_temp&.unlink
    txt_temp&.unlink
  end

  def extraer_con_pdf_reader(archivo)
    pdf_blob = archivo.pdf.download
    reader = PDF::Reader.new(StringIO.new(pdf_blob))
    reader.pages.map(&:text).join("\n")
  end
end