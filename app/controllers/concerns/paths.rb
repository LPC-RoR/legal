module Paths
	extend ActiveSupport::Concern

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
		when 'KrnDenuncia', 'KrnInvestigador', 'KrnEmpresaExterna', 'AppNomina', 'AppContacto'
			"/cuentas/#{objt.ownr.class.name[0].downcase}_#{objt.ownr.id}/#{krn_indx_action[objt.class.name]}"
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
		else
			objt.ownr
		end
	end

end