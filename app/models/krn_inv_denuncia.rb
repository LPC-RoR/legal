class KrnInvDenuncia < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_investigador

	has_many :pdf_registros, as: :ref

	def dnnc
		self.krn_denuncia
	end

	# Se usa para resolver bck_rdrccn
	def ownr
		self.krn_denuncia
	end
end
