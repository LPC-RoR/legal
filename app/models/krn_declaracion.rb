class KrnDeclaracion < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_investigador
 	belongs_to :ownr, polymorphic: true

 	scope :fecha_ordr, -> {order(fecha: :desc)}

 	def self.rlzds?
 		all.empty? ? false : all.map {|objt| objt.rlzd}.uniq.join('-') == 'true'
 	end
end
