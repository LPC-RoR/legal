module CptnProcsHelper

	PRFXS = {
		'KrnDenuncia' => 'karin'
	}

	def tab_proceso?
		['0', nil].include?(params[:id].split('_')[1])
	end

	def tab_participantes?
		params[:id].split('_')[1] == '1'
	end

	def proc_file_path(objt, dir, tsk)
		"app/views#{'/' if PRFXS[objt.class.name.to_s]}#{PRFXS[objt.class.name.to_s]}/#{cntrllr(objt)}/#{dir}/_#{tsk}.html.erb"
	end

	def proc_prtl(objt, dir, tsk)
		"#{PRFXS[objt.class.name.to_s]}/#{cntrllr(objt)}/#{dir}/#{tsk}"
	end

	def tsk_exist?(objt, tsk)
		File.exist?(proc_file_path(objt, 'proc', tsk))
	end

	def tsk_prtl(objt, tsk)
		proc_prtl(objt, 'proc', tsk)
	end

	def mssgs_exist?(objt, tsk)
		File.exist?(proc_file_path(objt, 'proc/mssgs', tsk))
	end

	def mssgs_prtl(objt, tsk)
		proc_prtl(objt, 'proc/mssgs', tsk)
	end

	def undo_exist?(objt, tsk)
		File.exist?(proc_file_path(objt, 'proc/undo', tsk))
	end

	def undo_prtl(objt, tsk)
		proc_prtl(objt, 'proc/undo', tsk)
	end

	# ----------------------------------------------- HASTA AQUI LA LÓGICA NUEVA

	def rcptr_lst(ownr)
		ownr.principal_usuaria ? ['Empresa', 'Dirección del Trabajo', 'Empresa externa'] : ['Empresa', 'Dirección del Trabajo']
	end

	def hide_last_crud?(codigo, ownr)
		last_crud_hsh = {
			'070_evlcn' => (not ownr.objcn_invstgdr?)
		}
		last_crud_hsh.keys.include?(codigo) ? last_crud_hsh[codigo] : false
	end

	def etp_muted(codigo, ownr)
		etp_mtd_hsh = {
			'etp_invstgcn' => ownr.on_dt?,
			'etp_prnncmnt' => ownr.prnncmnt_vncd
		}
		etp_mtd_hsh.keys.include?(codigo) ? etp_mtd_hsh[codigo] : false
	end

	def etp_hide(codigo, ownr)
		etp_hd_hsh = {
			'etp_prnncmnt' => ownr.on_dt?,
		}
		etp_hd_hsh.keys.include?(codigo) ? etp_hd_hsh[codigo] : false
	end

	def email_mask(email)
		mask = controller_name == 'krn_denuncias' ? 'prtcpnt@casa.cl' : 'admin@empresa.cl'
		[Rails.application.credentials[:dog][:email], 'hugo@edasoft.cl'].include?(email) ? mask : email
	end

	def objt_email_mask(objt)
		if objt.class.name == 'AppPerfil'
			[Rails.application.credentials[:dog][:email], 'hugo@edasoft.cl', 'hugo@laborsafe.cl'].include?(objt.email) ? 'admin@empresa.cl' : objt.email
		elsif objt.class.name.tableize.split('_')[0] == 'krn'
			"#{objt.class.name.tableize.split('_')[1]}@casa.cl"
		end
	end

end
