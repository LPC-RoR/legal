# app/services/pdf_ocr_reader.rb
class PdfOcrReader
  DPI = 300

  def self.texto_por_pagina(blob)
    Tempfile.create(['pdf', '.pdf'], binmode: true) do |pdf_file|
      pdf_file.write(blob.download)
      pdf_file.rewind
      reader = PDF::Reader.new(pdf_file)

      reader.pages.each_with_index.map do |pdf_page, idx|
        page_num = idx + 1
        raw_text = pdf_page.text.to_s
        palabras  = raw_text.scan(/\p{L}{3,}/).size

        if raw_text.empty? || palabras < 5   # <-- umbral original
          img = MiniMagick::Image.new(pdf_file.path + "[#{idx}]")
          img.density DPI
          img.format 'png'
          rt  = RTesseract.new(imagemagick_object: img)
          rt.lang = :spa
          { page: page_num, text: rt.to_s.strip, solo_image: true }
        else
          { page: page_num, text: raw_text,  solo_image: false }
        end
      end
    end
  end
end