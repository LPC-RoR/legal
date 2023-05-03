module CptnEstadosHelper

	def get_st_modelo(objeto)
		StModelo.find_by(st_modelo: objeto.class.name)
	end

	def get_st_estado(objeto)
		StModelo.find_by(st_modelo: objeto.class.name).st_estados.find_by(st_estado: objeto.estado)
	end

end