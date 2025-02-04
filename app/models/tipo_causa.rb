class TipoCausa < ApplicationRecord

	has_many :causas
	has_many :audiencias

# Dejamos este rastro para evaluar borrado de tabla var_tp_causas
#	has_many :var_tp_causas
#	has_many :variables, through: :var_tp_causas

	has_many :tar_tarifas
	has_many :tar_tipo_variables

	has_many :control_documentos, as: :ownr

	# Archivos controlados
	def acs
		control_documentos.acs
	end

	def dcs
		control_documentos.dcs
	end

end
