class Trabajador < ApplicationRecord
	has_many :doc_transacciones, as: :relacionable
end
