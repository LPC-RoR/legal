class Procedimiento < ApplicationRecord
	belongs_to :tipo_procedimiento

	has_many :tareas
end
