# app/models/email_legal.rb
class EmailLegal < ApplicationRecord
  belongs_to :act_archivo
  belongs_to :ownr, polymorphic: true, optional: true

  enum :estado, {
    pendiente:    0,
    encolado:     1,
    enviado:      2,
    fallido:      3,
    reintentando: 4
  }, prefix: true

  validates :destinatario, :reporte, presence: true
  
  scope :fallidos, -> { where(estado: :fallido) }
  scope :pendientes_envio, -> { where(estado: [:pendiente, :fallido, :reintentando]) }
end