module AppFormsHelper

	def form_txt(actn, objeto)
		"#{actn == 'new' ? (objeto.class.name == 'RepArchivo' ? 'Subir' : 'Crear') : 'Modificar'} #{m_to_name(objeto.class.name)}"
	end

	def form_class_excepctions
		{
			age_pendientes: 'oneFieldForm'
		}
	end

	def form_class(objeto)
		form_class_excepctions[object_class_sym(objeto)].blank? ? 'form-box' : form_class_excepctions[object_class_sym(objeto)]
	end

	def submit_text(objeto)
		['oneFieldForm'].include?(form_class(objeto)) ? '<i class="bi bi-caret-right"></i>'.html_safe : "#{ action_name == 'new' ? 'Crear' : 'Modificar'} #{m_to_name(objeto.class.name)}"
	end

end