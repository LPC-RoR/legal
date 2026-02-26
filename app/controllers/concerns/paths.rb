module Paths
	extend ActiveSupport::Concern

	## Manejo de redirect_to
	def default_redirect_path(objeto)
		case objeto.class.name
		when 'KrnInvestigador'
			"/cuentas/e_#{objeto.ownr.id}/invstgdrs"
		when 'KrnEmpresaExterna'
			"/cuentas/e_#{objeto.ownr.id}/extrns"
		when 'AppContacto'
			"/cuentas/e_#{objeto.ownr.id}/cntcts"
		when 'AppNomina'
			"/cuentas/e_#{objeto.ownr.id}/nmn"
		else
			if ['KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'].include?(objeto.class.name)
				"/krn_denuncias/#{objeto.dnnc.id}_1"
			end
		end
	end

	def key_redirect_path(objeto, key)
		nil
	end






  	def krn_indx_action
		{
			'KrnDenuncia' => 'dnncs',
			'KrnInvestigador' => 'invstgdrs',
			'KrnEmpresaExterna' => 'extrns',
			'AppNomina' => 'nmn',
			'AppContacto' => 'nmn',
		}
	end

	def bck_path_krn_objt(objt)
		case objt.class.name
		when 'Empresa', 'Cliente' 
			"/cuentas/#{objt.class.name[0].downcase}_#{objt.id}/dnncs"
		when 'KrnDenuncia', 'KrnInvestigador', 'KrnEmpresaExterna', 'AppContacto'
			"/cuentas/#{objt.ownr.class.name[0].downcase}_#{objt.ownr.id}/#{krn_indx_action[objt.class.name]}"
		when 'AppNomina'
			objt.ownr_id.nil? ? app_nominas_path : "/cuentas/e_#{objt.ownr_id}/nmn"
		else
			objt.ownr
		end
	end

	def bck_act_archivo_path(objt)
		case objt.ownr.class.name
		when 'KrnDenuncia'
			objt.ownr
		when 'KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'
			"/krn_denuncias/#{objt.ownr.dnnc.id}_1"
		end
	end

	# ------------------------------------------------------ APP_NOMINA
	def app_nmn_rdrct_path(objt)
		objt.ownr_id.nil? ? app_nominas_path : "/cuentas/#{objt.ownr.class.name[0].downcase}_#{objt.ownr_id}/nmn"
	end	
	# ------------------------------------------------------ ACT_ARCHIVO

	def dnnc_shw_path(objt)
		if objt.class == ActArchivo
			dnnc_id = "#{objt.ownr.dnnc.id}_#{objt.ownr.class.name == 'KrnDenuncia' ? (['combinado', 'dnnc'].include?(objt.act_archivo) ? '2' : '0') : '1'}"
		elsif ['KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'].include?(objt.class.name)
			dnnc_id = "#{objt.ownr.dnnc.id}_1"
		else
			dnnc_id = "#{objt.ownr.dnnc.id}_0"
		end
		"/krn_denuncias/#{dnnc_id}"
	end

	def act_archivo_rdrccn(objt)
		if ['KrnDenuncia', 'KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'].include?(objt.ownr.class.name)
			dnnc_shw_path(objt)
		elsif objt.anonimizado_de.present?
			dnnc_shw_path(objt.anonimizado_de)
		else
			objt.ownr
		end
	end

	# ------------------------------------------------------ AGE_ACTIVIDAD

	def actvdd_path(orgn)
		case orgn
		when 'dshbrd'
			authenticated_root_path
		end
	end
end