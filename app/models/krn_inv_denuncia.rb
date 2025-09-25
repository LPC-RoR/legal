class KrnInvDenuncia < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_investigador

	has_many :pdf_registros, as: :ref, dependent: :destroy

	def dnnc
		self.krn_denuncia
	end

	def dflt_bck_rdrccn
		"/krn_denuncias/#{self.dnnc.id}_0"
	end

	# Se usa para resolver bck_rdrccn
	def ownr
		self.krn_denuncia
	end
end
