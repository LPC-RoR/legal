class KrnDeclaracion < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_investigador
 	belongs_to :ownr, polymorphic: true

	has_many :pdf_registros, as: :ref

    validates_presence_of :fecha

 	scope :fecha_ordr, -> {order(fecha: :desc)}

 	def dnnc
 		self.ownr.dnnc
 	end

	def dflt_bck_rdrccn
		"/krn_denuncias/#{self.dnnc.id}_1"
	end

 	def self.rlzds?
 		all.empty? ? false : all.map {|objt| objt.fl_dclrcn?}.uniq.join('-') == 'true'
 	end

 	def fl_dclrcn?
 		self.ownr.fl?('prtcpnts_dclrcn').present?
 	end

 	def invstgdr_objtd?
 		self.krn_denuncia.objcn_invstgdr? and self.krn_denuncia.krn_inv_denuncias.first.id == self.krn_investigador_id
 	end

 	def invstgdr_elmnd?
 		self.krn_denuncia.krn_investigadores.ids.include?(self.krn_investigador_id) == false
 	end
end
