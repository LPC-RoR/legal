class Seccion < ApplicationRecord
	belongs_to :causa

	has_many :parrafos
end
