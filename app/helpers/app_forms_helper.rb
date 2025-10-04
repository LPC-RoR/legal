module AppFormsHelper


	def form_txt(actn, objeto)
		"#{actn == 'new' ? (objeto.class.name == 'RepArchivo' ? 'Subir' : 'Crear') : 'Modificar'} #{to_name(objeto.class.name)}"
	end

end