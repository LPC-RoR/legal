class ClssKrnHnts

	HNTS_DIR = 'hnts'

	HNTS_TTL = {
		etp_rcpcn: {
			tsk_ingrs: {
				1 => 'Ingresar los datos de las personas denunciante y denunciada.'
			}
		}
	}

	def self.tsk_tab_hnt?(kproc, tab)
		File.exist?(proc_file(kproc, HNTS_DIR, tab))
	end

	def self.tsk_tab_hnt_prtl(kproc, tab)
		"karin/kproc/#{HNTS_DIR}/#{kproc.etapa.to_s}_#{kproc.tarea}_#{tab}"
	end

	def self.hnt_ttl(kproc, tab)
		HNTS_TTL[kproc.etapa][kproc.tarea.to_sym][tab]
	end

	private

	def self.proc_file(kproc, dir, tab)
		"app/views/karin/kproc/#{HNTS_DIR}/_#{kproc.etapa.to_s}_#{kproc.tarea}_#{tab}.html.erb"
	end

end