class TribunalCorte < ApplicationRecord

	has_many :causas

	scope :trbnl_ordr, -> {order(:tribunal_corte)}

    validates_presence_of :tribunal_corte
	validates :tribunal_corte, uniqueness: true

	# Método que me entrega el hacs id => razon_social
	# Alternativa usando pluck (más eficiente para ActiveRecord::Relation)
	def self.to_options_hash
		pluck(:id, :tribunal_corte).to_h
	end

end
