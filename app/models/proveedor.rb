class Proveedor < ApplicationRecord
	has_many :doc_transacciones, as: :relacionable
	has_many :doc_recibidos

	has_many :doc_boletas, as: :ownr
end
