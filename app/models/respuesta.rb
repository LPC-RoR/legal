class Respuesta < ApplicationRecord
	belongs_to :k_sesion
	belongs_to :pregunta
end
