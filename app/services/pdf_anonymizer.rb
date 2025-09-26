# app/services/pdf_anonymizer.rb
# frozen_string_literal: true

require "pdf/reader"
require "prawn"
require "tempfile"
require "fileutils"

class PdfAnonymizer
  attr_reader :act_archivo, :replacements

  # act_archivo: instancia de ActArchivo que TIENE un pdf adjuntado
  # replacements: Hash { "Texto a buscar" => "Texto de reemplazo" }
  def initialize(act_archivo, replacements = {})
    @act_archivo  = act_archivo
    @replacements = replacements
  end

  # Devuelve el nuevo ActArchivo con el PDF anonimizado
  def call
    raise ArgumentError, " replacements vacío" if replacements.blank?
    raise "El ActArchivo no tiene PDF adjunto" unless act_archivo.pdf.attached?

    original_path = download_original
    plain_text    = pdf_to_text(original_path)
    anon_text     = anonymize(plain_text)
    new_pdf_io    = text_to_pdf(anon_text)

    create_new_act_archivo(new_pdf_io)
  ensure
    FileUtils.rm(original_path) if original_path && File.exist?(original_path)
  end

  private

  # Descarga el blob a un tempfile binario
  def download_original
    tmp = Tempfile.new(["original", ".pdf"], binmode: true)
    act_archivo.pdf.download { |chunk| tmp.write(chunk) }
    tmp.close
    tmp.path
  end

  # Extrae el texto completo del PDF
  def pdf_to_text(path)
    reader = PDF::Reader.new(path)
    reader.pages.map(&:text).join("\n")
  end

  # Reemplaza todas las ocurrencias (case-sensitive por defecto)
  def anonymize(text)
    replacements.reduce(text) do |txt, (old, new_)|
      txt.gsub(old, new_)
    end
  end

  # Crea un nuevo PDF en memoria con el texto anonimizado
  def text_to_pdf(text)
    StringIO.new.tap do |io|
      Prawn::Document.new do |pdf|
        pdf.text text
      end.render(io)
      io.rewind
    end
  end

  # Crea y persiste el segundo ActArchivo adjuntando el PDF generado
  def create_new_act_archivo(pdf_io)
    denuncia = act_archivo.denuncia
    new_aa   = denuncia.act_archivos.build

    new_aa.pdf.attach(
      io:           pdf_io,
      filename:     "denuncia_anonimizada_#{SecureRandom.hex(8)}.pdf",
      content_type: "application/pdf"
    )
    new_aa.save!
    new_aa
  end
end