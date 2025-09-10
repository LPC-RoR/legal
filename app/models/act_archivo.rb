class ActArchivo < ApplicationRecord
  belongs_to :ownr, polymorphic: true
  has_one_attached :pdf

  MAX_PDF_SIZE = 20.megabytes

  validate :pdf_valid
  validate :safe_pdf

  validates :fecha, presence: true, if: -> {self.mdl.constantize.act_fecha(self.act_archivo)}
  validates_presence_of :act_archivo
  validates_presence_of :nombre, if: -> {self.mdl.constantize.act_lst?(self.act_archivo)}

  scope :act_ordr, -> { order(:act_archivo) }
  scope :crtd_ordr, -> { order(created_at: :desc) }
  scope :fecha_ordr, -> { order(:fecha) }

  private

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


