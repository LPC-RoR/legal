class ActArchivo < ApplicationRecord
  attr_accessor :skip_pdf_presence

  belongs_to :ownr, polymorphic: true, optional: true

  belongs_to :anonimizado_de, class_name: 'ActArchivo', optional: true
  has_one    :anonimizado_como, class_name: 'ActArchivo',
  foreign_key: 'anonimizado_de_id', dependent: :destroy

  has_one_attached :pdf
  has_many :act_textos, dependent: :destroy
  has_many :act_metadatas, dependent: :destroy

  MAX_PDF_SIZE = 20.megabytes

  validate :pdf_valid, unless: -> {self.rlzd}
  validate :safe_pdf, unless: -> {self.rlzd}
  validate :pdf_must_be_attached_unless_rlzd

  validates :fecha, presence: true, if: -> { mdl.present? && mdl.constantize.try(:act_fecha, act_archivo) }
  validates_presence_of :act_archivo
  validates :nombre, presence: true, if: -> { mdl.present? && mdl.constantize.try(:act_lst?, act_archivo) }

  scope :originales,   -> { where(anonimizado: false) }
  scope :anonimizados, -> { where(anonimizado: true) }

  scope :act_ordr, -> { order(:act_archivo) }
  scope :crtd_ordr, -> { order(created_at: :desc) }
  scope :fecha_ordr, -> { order(:fecha) }

  scope :with_attached_pdf, -> { includes(pdf_attachment: :blob) }

#  after_create :procesar_demanda, if: :es_demanda?
  # Cambiar after_create por after_commit
  after_commit :procesar_demanda, on: :create, if: :es_demanda?

  # Métodos para acceder fácilmente a los textos
  def lista_participantes_texto
    act_textos.lista_participantes.first
  end

  def resumen_anonimizado_texto
    act_textos.resumen_anonimizado.first
  end

  def lista_hechos_texto
    act_textos.lista_hechos.first
  end

  def pdf_para(modo = :original)
    case modo
    when :anonimizado
      anonimizado_como || self
    else
      self
    end
  end

    # Add processing status methods
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

  def procesar_demanda
    ProcesadorDemandaJob.perform_later(self.id)
  end

  def pdf_must_be_attached_unless_rlzd
    return if rlzd || skip_pdf_presence
    errors.add(:pdf, "debe estar adjunto si no está realizado") unless pdf.attached?
  end

  def pdf_valid
    return unless pdf.attached?

    # 1. Validar contenido MIME real (no solo la extensión)
    unless pdf.content_type.in?(%w[application/pdf])
      errors.add(:pdf, "debe ser un archivo PDF")
      return
    end

    # 2. Validar tamaño máximo (ej. 5 MB)
    if pdf.byte_size > MAX_PDF_SIZE
      errors.add(:pdf, "supera el límite de #{MAX_PDF_SIZE / 1.megabyte}MB")
    end

    # 3. Validar extensión del archivo (doble seguridad)
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

  # ¿Está este documento se subió
  def self.act_archv_exst?(ownr, cdg)
    ActArchivo.exists?(ownr_type: ownr.class.name, ownr_id: ownr.id, cdg: cdg)
  end

end
