# MOdelo para ActTexto, los de ActArchivo están en ClssTipos

class ClssActs
	def self.nombre
		{
			'lista_participantes'	=> 'Claves de los participantes',
			'resumen_anonimizado'	=> 'Resumen de la cuantía',
			'lista_hechos'			=> 'Lista de Hechos'
		}		
	end

	# Definidas para LglRepositorio

	def self.lgl_dcmnts
		['ley']
	end

	def self.act_nombre
		{
			'ley'						=> 'Ley'
		}
	end

	def self.act_lst?(act_code)
		case act_code
		when nil
			false
		end
	end

	def self.act_fecha(act_code)
		case act_code
		when nil
			false
		end
	end
end