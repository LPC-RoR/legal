class Trabajador < ApplicationRecord
	has_many :doc_transacciones, as: :relacionable

	has_many :doc_boletas, as: :ownr
end