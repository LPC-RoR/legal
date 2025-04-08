class ProDtllVenta < ApplicationRecord
	belongs_to :ownr, polymorphic: true, optional: true
	belongs_to :producto

	scope :fecha_ordr, -> {order(fecha_activacion: :desc)}

    delegate :codigo, :formato, :prepago, :capacidad, :moneda, :precio, to: :producto
end
