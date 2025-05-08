class PdfRegistro < ApplicationRecord
	belongs_to :ownr, polymorphic: true
	belongs_to :ref, polymorphic: true, optional: true
	belongs_to :pdf_archivo

	def rdrccn
		if ['KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'].include?(self.ownr_type)
			"/krn_denuncias/#{self.ownr.dnnc.id}_1"
		else
			case self.ref_type
			when 'KrnDenuncia'
				"/krn_denuncias/#{self.ref.dnnc.id}_2"
			else
				self.ownr
			end
		end
	end
end
