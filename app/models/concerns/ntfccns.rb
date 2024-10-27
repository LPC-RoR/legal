module Ntfccns
 	extend ActiveSupport::Concern

	def m_ntfccn
		m_vlr(self, 'ntfccn')
	end

	def ntfccn?
		ntf = self.m_ntfccn
		ntf.blank? ? nil : ntf.c_texto
	end

	def ntf_chck?
		self.articulo_516 ? self.m_ntfccn.present? : true
	end

end