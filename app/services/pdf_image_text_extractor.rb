# app/services/pdf_image_text_extractor.rb
require 'mini_magick'
require 'rtesseract'
require 'tempfile'
require 'fileutils'
require 'pdf-reader'

class PdfImageTextExtractor
  DPI  = 300
  LANG = 'spa'
  PSM  = 6

  def self.texto_por_pagina(blob)
    pdf_path = blob.service.path_for(blob.key)
    reader   = PDF::Reader.new(pdf_path)
    total    = reader.page_count

    (1..total).map do |page_num|
      png_path = render_page(pdf_path, page_num)
      text     = RTesseract.new(png_path, lang: LANG, psm: PSM).to_s
      text     = text.gsub(/-\n/, '').gsub(/\s+/, ' ').strip
      FileUtils.rm_f(png_path)
      { page: page_num, text: text }
    end
  end

  private

  def self.render_page(pdf, page)
    tmp_dir = '/tmp'
    base    = File.join(tmp_dir, "page_#{SecureRandom.hex(8)}")
    ok      = system('pdftoppm', '-f', page.to_s, '-l', page.to_s,
                     '-png', '-r', DPI.to_s, pdf, base)
    out_png = Dir["#{base}-*.png"].first
    raise "pdftoppm falló página #{page}" unless ok && out_png && File.exist?(out_png)
    out_png
  end
end