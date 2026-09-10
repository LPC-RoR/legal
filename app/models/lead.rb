class Lead < ApplicationRecord
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

  scope :pendientes, -> { where(estado: %i[nuevo contactado calificado]) }

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