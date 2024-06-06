class Cargo < ApplicationRecord
	belongs_to :tipo_cargo
	belongs_to :cliente
end
