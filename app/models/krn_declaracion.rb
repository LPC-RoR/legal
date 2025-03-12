class KrnDeclaracion < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_investigador
 	belongs_to :ownr, polymorphic: true

 	scope :fecha_ordr, -> {order(fecha: :desc)}

 	def self.rlzds?
 		arr = all.map {|dec| dec.rlzd}.uniq
 		arr == [] or (arr.length == 1 and arr[0] == true)
 	end
end
