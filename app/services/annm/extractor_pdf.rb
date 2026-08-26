# app/services/annm/extractor_pdf.rb
module Annm
  class ExtractorPdf
    def self.extract(attachment)
      return "" unless attachment.attached?

      attachment.blob.open do |file|
        reader = PDF::Reader.new(file.path)
        reader.pages.map(&:text).join("\n")
      end
    rescue => e
      Rails.logger.error "[Annm::ExtractorPdf] Error extrayendo PDF: #{e.message}"
      ""
    end
  end
end