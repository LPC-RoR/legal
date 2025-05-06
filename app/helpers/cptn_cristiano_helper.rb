module CptnCristianoHelper

	# controlador SIN prefijo por alias
	def get_controller(controller)
		simple = controller.split('-').last
		app_alias[simple].blank? ? simple : app_alias[simple]
	end

	# excepciones de campos
	def f_excepciones 
		{
			'created_at' => 'fecha',
			'sha1' => 'clave'
		}
	end

	# corrige nombres de campos
	def corrige_campo(field)
		if f_excepciones.keys.include?(field)		
			f_excepciones[field]
		else
			text = field.match(scopes) ? field.gsub(scopes, '') : field
			text.humanize.split.map {|word| corrige(word.downcase)}.join(' ').capitalize
		end
	end

	#**********************************************************************   APP   *************************************************************

	def app_alias 
		{
			'alias' => 'controlador'
		}
	end

end