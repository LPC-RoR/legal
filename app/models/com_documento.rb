class ComDocumento < ApplicationRecord
  has_one_attached :file

  validates :codigo, :titulo, :doc_type, presence: true
  validate  :pdf_only

  private
  def pdf_only
    if file.attached? && file.content_type != "application/pdf"
      errors.add(:file, "debe ser PDF")
    end
  end
end