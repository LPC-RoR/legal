class TribunalCorte < ApplicationRecord

	has_many :causas

	scope :trbnl_ordr, -> {order(:tribunal_corte)}

    validates_presence_of :tribunal_corte
	validates :tribunal_corte, uniqueness: true

end
