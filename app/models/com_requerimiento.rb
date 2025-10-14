class ComRequerimiento < ApplicationRecord
    attr_accessor :website  # honeypot

    belongs_to :ownr, optional: true

    has_many :notas, as: :ownr

	validates :rut, valida_rut: true
    validates_presence_of :razon_social, :nombre, :email

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :razon_social, length: { maximum: 50 }
    validates :nombre, length: { maximum: 100 }

	scope :rut_ordr, -> {order(:rut)}

    include EmailVerifiable

end
