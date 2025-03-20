module Fls
 	extend ActiveSupport::Concern
	# ------------------------------------------------------------------------ REP ARCHIVOS

	# Archivos existentes de un documento controlado multiple
	def fls(dc)
		self.rep_archivos.where(rep_doc_controlado_id: dc.id).crtd_ordr
	end

	# Archivos existentes de un documento controlado simple
	def fl(dc)
		self.fls(dc).last
	end

	def fl?(code)
		dc = RepDocControlado.get_dc(code)
		fl(dc).present?
	end

	def fl_last_date(code)
		dc = RepDocControlado.get_dc(code)
		ars = dc.blank? ? [] : self.rep_archivos.where(rep_doc_controlado_id: dc.id)
		ars.blank? ? nil : ars.map {|arch| arch.fecha}.max
	end
end