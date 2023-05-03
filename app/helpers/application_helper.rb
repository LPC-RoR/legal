module ApplicationHelper

#*******************************************************************************************************************
#*******************************************************************************************************************
	# DEPRECATED
#	def objeto_tema_ayuda(tipo)
#		TemaAyuda.where(tipo: tipo).any? ? TemaAyuda.where(tipo: tipo).first : nil
#	end

	# DEPRECATED
#	def coleccion_tema_ayuda(tipo)
#		temas_ayuda_tipo = TemaAyuda.where(tipo: tipo)
#		if temas_ayuda_tipo.any?
#			temas_ayuda_activos = temas_ayuda_tipo.where(activo: true)
#			temas_ayuda_activos.any? ? temas_ayuda_activos.order(:orden) : nil
#		else
#			nil
#		end
#	end

	# DEPRECATED EN REVISION
	def url_params(parametros)
		params_options = "n_params=#{parametros.length}"
		parametros.each_with_index do |obj, indice|
			params_options = params_options+"&class_name#{indice+1}=#{obj.class.name}&obj_id#{indice+1}=#{obj.id}"
		end
		params_options
	end

	# DEPRECATED EN REVISION
	def text_with_badge(text, badge_value=nil)
	    badge = content_tag :span, badge_value, class: 'badge badge-primary badge-pill'
	    text = raw "#{text} #{badge}" if badge_value
	    return text
	end

end
