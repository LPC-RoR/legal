class Lead < ApplicationRecord
  KINDS = %w[presentacion diagnostico].freeze

  belongs_to :empresa, optional: true

  enum :estado, {
    nuevo: 0,
    contactado: 1,
    calificado: 2,
    convertido: 3,
    descartado: 4
  }

  validates :nombre, :email, :telefono, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :kind, inclusion: { in: KINDS }
  validates :pregunta, length: { maximum: 2000 }

  scope :pendientes, -> { where(estado: %i[nuevo contactado calificado]) }
  scope :diagnosticos, -> { where(kind: "diagnostico") }

  # Prioridad comercial: diagnósticos con una denuncia abierta real
  scope :con_denuncia_abierta, -> { diagnosticos.where("respuestas ->> 'denuncia_abierta' = 'si'") }

  def diagnostico?
    kind == "diagnostico"
  end

  def respuesta(clave)
    respuestas[clave.to_s]
  end

  # Solo se llama cuando la gestión comercial fue exitosa.
  # RUT y razón social se piden aquí, no en el formulario público.
  def convertir_a_empresa!(rut:, razon_social:, usuario_asignado: nil, **empresa_attrs)
    raise "Lead ya convertido" if convertido?

    transaction do
      empresa = Empresa.create!(
        rut: rut,
        razon_social: razon_social,
        nombre_contacto: nombre,
        email_contacto: email,
        telefono_contacto: telefono,
        **empresa_attrs
      )
      update!(estado: :convertido, empresa: empresa)
      empresa
    end
  end
end