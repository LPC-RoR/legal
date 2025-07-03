module AppFormsHelper

	# Botón Back en formularios
	def bck_rdrccn(objeto)
		clss = objeto.class.name
		ownr = objeto.ownr
		if ['AppNomina', 'AppContacto'].include?(clss) and ownr.present?
			['Empresa', 'Cliente'].include?(ownr.class.name) ? "/cuentas/#{ownr.class.name[0].downcase}_#{ownr.id}/nmn" : "/#{clss.tableize}"
		elsif ['KrnDenunciante', 'KrnDenunciado', 'KrnTestigo', 'KrnDeclaracion'].include?(clss) and ownr.present?
			"/krn_denuncias/#{ownr.dnnc.id}_1"
		elsif ['KrnInvDenuncia', 'KrnDerivacion'].include?(clss) and ownr.present?
			"/krn_denuncias/#{ownr.id}_0"
		else
			case clss
			when 'KrnDenuncia'
				"/cuentas/#{ownr.class.name[0].downcase}_#{ownr.id}/dnncs"
			when 'KrnInvestigador'
				"/cuentas/#{ownr.class.name[0].downcase}_#{ownr.id}/invstgdrs"
			when 'KrnEmpresaExterna'
				"/cuentas/#{ownr.class.name[0].downcase}_#{ownr.id}/extrns"
			when 'RepArchivo'
				if ['KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'].include?(ownr.class.name)
					"/krn_denuncias/#{ownr.dnnc.id}_1"
				elsif ['KrnDenuncia'].include?(ownr.class.name)
					"/krn_denuncias/#{ownr.dnnc.id}_0"
				else
					ownr
				end
			when 'Nota'
				case ownr.class.name
				when 'KrnDenuncia'
					"/krn_denuncias/#{ownr.dnnc.id}_0"
				else
					ownr
				end
			else
				"/#{clss.tableize}"
			end
		end
	end

	# -----------------------------------------------------------------------------------------------------------

	def form_txt(actn, objeto)
		"#{actn == 'new' ? (objeto.class.name == 'RepArchivo' ? 'Subir' : 'Crear') : 'Modificar'} #{to_name(objeto.class.name)}"
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
		['oneFieldForm'].include?(form_class(objeto)) ? '<i class="bi bi-caret-right"></i>'.html_safe : "#{ action_name == 'new' ? 'Crear' : 'Modificar'} #{to_name(objeto.class.name)}"
	end

end