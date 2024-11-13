class Producto < ApplicationRecord
	TIPOS = ['Procedimiento', 'Capacitación', 'Asesoría', 'Capacidad']

	belongs_to :procedimiento, optional: true

	scope :lst, -> {order(:producto)}

	def self.lista
		Producto.lst.map {|prdct| "#{prdct.producto} : #{prdct.formato}"}
	end

end