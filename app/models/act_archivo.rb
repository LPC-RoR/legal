# app/models/act_archivo.rb
class ActArchivo < ApplicationRecord
  include ActArchivo::PdfEmailer
  include ActArchivo::Anonimizador

  belongs_to :ownr, polymorphic: true, optional: true

  belongs_to :anonimizado_de, class_name: 'ActArchivo', optional: true
  has_one    :anonimizado_como, class_name: 'ActArchivo',
             foreign_key: 'anonimizado_de_id', dependent: :destroy

  has_one_attached :pdf

  has_many :act_referencias, dependent: :destroy
  has_many :email_legales, dependent: :nullify
  has_many :krn_textos, as: :ownr, dependent: :destroy
  accepts_nested_attributes_for :krn_textos, allow_destroy: true

  MAX_PDF_SIZE = 40.megabytes

  validate :pdf_valid, unless: -> { self.rlzd }
  validate :safe_pdf,  unless: -> { self.rlzd }

  validates :fecha, presence: true, if: -> { mdl.present? && mdl.constantize.try(:act_fecha, act_archivo) }
  validates_presence_of :act_archivo
  validates :nombre, presence: true, if: -> { mdl.present? && mdl.constantize.try(:act_lst?, act_archivo) }

  scope :originales,   -> { where(anonimizado: false) }
  scope :anonimizados, -> { where(anonimizado: true) }

  scope :act_ordr,    -> { order(:act_archivo) }
  scope :crtd_ordr,   -> { order(created_at: :desc) }
  scope :fecha_ordr,  -> { order(:fecha) }

  scope :where_code,        ->(code) { where(act_archivo: code) }
  scope :with_attached_pdf, -> { includes(pdf_attachment: :blob) }

  def refs
    act_referencias.includes(:ref).map(&:ref)
  end

  def pdf_para(modo = :original)
    case modo
    when :anonimizado
      anonimizado_como || self
    else
      self
    end
  end

  # --------------------------------------------------------------
  # Processing status
  # --------------------------------------------------------------
  def processing_status
    self[:processing_status] || 'pending'
  end

  def mark_processing!
    update_column(:processing_status, 'processing')
    Rails.logger.info("[ActArchivo] 🏷️ Marked as processing: #{id}")
  end

  def mark_completed!
    update_columns(
      processing_status: 'completed',
      processed_at: Time.current
    )
    Rails.logger.info("[ActArchivo] ✅ Marked as completed: #{id}")
  end

  def mark_failed!
    update_column(:processing_status, 'failed')
    Rails.logger.info("[ActArchivo] ❌ Marked as failed: #{id}")
  end

  private

  def es_demanda?
    act_archivo == "demanda"
  end

  def pdf_valid
    return unless pdf.attached?

    unless pdf.content_type.in?(%w[application/pdf])
      errors.add(:pdf, "debe ser un archivo PDF")
      return
    end

    if pdf.byte_size > MAX_PDF_SIZE
      errors.add(:pdf, "supera el límite de #{MAX_PDF_SIZE / 1.megabyte}MB")
    end

    unless pdf.filename.to_s.downcase.end_with?('.pdf')
      errors.add(:pdf, "debe tener extensión .pdf")
    end
  end

  def safe_pdf
    return unless pdf.attached?

    pdf.open do |file|
      begin
        reader = PDF::Reader.new(file)

        if reader.page_count > 500
          errors.add(:pdf, 'tiene demasiadas páginas (máx. 500)')
          return
        end

        if reader.objects.any? { |_, obj| executable?(obj) }
          errors.add(:pdf, 'contiene código ejecutable no permitido')
          return
        end

      rescue PDF::Reader::MalformedPDFError
        errors.add(:pdf, 'está corrupto o no es un PDF válido')
      end
    end
  rescue ActiveStorage::FileNotFoundError
    # ignoramos: el archivo aún no está listo; lo validaremos después
  end

  def executable?(obj)
    return false unless obj.is_a?(Hash)
    obj[:JS] || obj[:S] == :JavaScript || obj[:Type] == :Action &&
      %i[Launch Sound Movie ResetForm ImportData].include?(obj[:S])
  end
end