module CptnProcsHelper

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

end
