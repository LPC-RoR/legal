module Paths
	extend ActiveSupport::Concern

	## default_redirect_path(objeto) se usa para modelos sin muchos contextos
	## ActArchivo y KrnTexto tienen sus propios métodos

	## DENUNCIA
	def dnnc_path(dnnc, tab_id)
		"/krn_denuncias/#{dnnc.id}_#{tab_id}"
	end

	def new_dnnc_path(dnnc)
		"/krn_denuncias/#{dnnc.id}_1"
	end

	# EMPRESA
	def emprs_path(emprs, mthd)
		"/cuentas/e_#{emprs.id}/#{mthd}"
	end

	def emprs_tab_mthd(objt)
		case objt.class.name
		when 'KrnDenuncia'
			'dnncs'
		when 'KrnInvestigador'
			'invstgdrs'
		when 'KrnEmpresaExterna'
			'extrns'
		when 'AppContacto'
			'cntcts'
		end
	end

	## Manejo de redirect_to
	def default_redirect_path(objeto)
		if usuario_signed_in?
			case objeto.class.name
			when 'Empresa'
				empresas_path
			when 'KrnDenuncia', 'KrnInvestigador', 'KrnEmpresaExterna', 'AppContacto'
				emprs_path(objeto.ownr, emprs_tab_mthd(objeto))
			when 'AppNomina'
				objeto.ownr ? emprs_path(objeto.ownr, 'nmn') : app_nominas_path
			when 'KrnInvDenuncia', 'KrnDerivacion'
				dnnc_path(objeto.krn_denuncia, 0)
			when 'KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'
				dnnc_path(objeto.krn_denuncia, 1)
			when 'KrnDeclaracion'
				dnnc_path(objeto.ownr.dnnc, 2)
			when 'KrnTexto'
				txt_path(objeto)
			end
		else
			root_path
		end
	end

	## KrnTexto
	def txt_path(objt)
		case objt.ownr.class.name
		when 'KrnDenuncia'
			dnnc_path(objt.ownr, 0)
		when 'KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'
			ClssPdfRprt.tab_dclrcns_rprt?(objt.codigo) ? dnnc_path(objt.ownr.dnnc, 2) : dnnc_path(objt.ownr.dnnc, 1)
		when 'KrnInvestigador'
			krn_investigador_path(objt.ownr)
		when 'Empresa'
			objt.ownr
		when 'ActArchivo'
			bck_act_archivo_path(objt.ownr)
		when 'Causa'
			"/causas/#{@objeto.id}?html_options[menu]=#{prm_safe('Tarifa & Pagos')}"
		end
	end

	## Hasta aquí revisado pero sin una prueba exhaustiva

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
		when 'KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'
			"/krn_denuncias/#{objt.krn_denuncia.id}_1"
		when 'KrnDerivacion'
			"/krn_denuncias/#{objt.krn_denuncia.id}_1"
		when 'KrnTexto'
			txt_path(objt)
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
			if ClssPdfRprt.tab_rcrss_rprt?(objt.act_archivo)
				dnnc_id = "#{objt.ownr.dnnc.id}_3"
			elsif ClssPdfRprt.tab_dclrcns_rprt?(objt.act_archivo)
				dnnc_id = "#{objt.ownr.dnnc.id}_2"
			elsif objt.ownr.class.name == 'KrnDenuncia'
				dnnc_id = "#{objt.ownr.dnnc.id}_0"
			else
				dnnc_id = "#{objt.ownr.dnnc.id}_1"
			end
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