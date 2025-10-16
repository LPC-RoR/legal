# app/services/pdf_image_text_extractor.rb
require 'mini_magick'
require 'rtesseract'
require 'tempfile'
require 'pdf-reader'
require 'filemagic'
require 'zlib'        # ← agrega esta línea

class PdfImageTextExtractor
  DPI   = 300
  MAGIC = FileMagic.new(FileMagic::MAGIC_MIME)

  # devuelve Hash { página => [ { idx: 1, text: "..." }, ... ] }
  # textos SIN marcas [IMAGEN-X-Y]; el integrador los agrega.
  def self.textos_por_pagina(blob)
# dentro de PdfImageTextExtractor#textos_por_pagina
    Tempfile.create(['pdf', '.pdf'], binmode: true) do |pdf_file|
      pdf_file.write(blob.download)
      pdf_file.rewind
      reader = PDF::Reader.new(pdf_file)
      out    = {}

      reader.pages.each_with_index do |page, idx|
        page_num = idx + 1
        images   = page.xobjects.select { |_, obj| obj.hash[:Subtype] == :Image }
        next if images.empty?

        out[page_num] = images.map.with_index do |(name, obj), i|
          data = obj.data
          mime = MAGIC.buffer(data)

          # si no es imagen real → texto vacío
          next { idx: i + 1, text: '[sin texto]' } unless mime.start_with?('image/')

          # dentro de PdfImageTextExtractor#textos_por_pagina
          # dentro de PdfImageTextExtractor#textos_por_pagina
          text = begin
                   Tempfile.create(['img', ''], binmode: true) do |dst|
                     dst.write(Zlib::Inflate.inflate(data))
                     dst.rewind
                     system('convert', '-density', DPI.to_s, dst.path, 'png:' + dst.path, exception: true)
                     RTesseract.new(dst.path, lang: :spa).to_s.strip
                   end
                 rescue StandardError
                   '[sin texto]'
                 end
              
          { idx: i + 1, text: text.presence || '[sin texto]' }
        end
      end
      out
    end
  end
end