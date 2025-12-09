class TarAprobacion < ApplicationRecord
	belongs_to :cliente
	
	has_many :tar_facturaciones
	has_many :tar_calculos

	has_one :act_archivo, as: :ownr, dependent: :destroy

	scope :ordr, -> { order(fecha: :desc) }

  # Método conveniencia
  def generar_pdf_en_background
    ::PdfGenerationJob.perform_later(self.class.name, id)
  end

end
