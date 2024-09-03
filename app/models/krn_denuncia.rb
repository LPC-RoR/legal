class KrnDenuncia < ApplicationRecord
	belongs_to :cliente, optional: true
	belongs_to :motivo_denuncia
	belongs_to :receptor_denuncia
	belongs_to :dependencia_denunciante

	has_many :krn_denunciantes

	has_many :krn_denunciados

	def owner
#		self.cliente_id.blank? ? self.empresa : self.cliente
		self.cliente
	end

	def app_archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	def cmptnc_emprss
		emprss_dnncnts_ids = self.krn_denunciantes.map {|dnncnt| dnncnt.krn_empresa_externa_id}.uniq
		emprss_dnncd_ids = self.krn_denunciados.map {|dnncd| dnncd.krn_empresa_externa_id}.uniq 
		emprss_ids = ( emprss_dnncnts_ids + emprss_dnncd_ids ).uniq
		emprss_ids.length == 1 ? ( emprss_ids[0] == nil ? 'Empresa' : 'Empresa externa') : 'Empresa'
	end
end
