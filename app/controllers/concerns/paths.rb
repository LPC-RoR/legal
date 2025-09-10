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
		if ['Empresa', 'Cliente'].include?(objt.class.name)
			"/cuentas/#{objt.class.name[0].downcase}_#{objt.id}/dnncs"
		elsif ['KrnDenuncia', 'KrnInvestigador', 'KrnEmpresaExterna', 'AppNomina', 'AppContacto'].include?(objt.class.name)
			"/cuentas/#{objt.ownr.class.name[0].downcase}_#{objt.ownr.id}/#{krn_indx_action[objt.class.name]}"
		end
	end

	def bck_act_archivo_path(objt)
		if ['KrnDenuncia'].include?(objt.ownr.class.name)
			objt.ownr
		elsif ['KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'].include?(objt.ownr.class.name)
			"/krn_denuncias/#{objt.ownr.dnnc.id}_1"
		end
	end
end