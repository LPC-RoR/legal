class KrnTestigo < ApplicationRecord
 	belongs_to :ownr, polymorphic: true
	belongs_to :krn_empresa_externa, optional: true

	has_many :krn_declaraciones, as: :ownr
	has_many :rep_archivos, as: :ownr

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true, if: -> {rut.present?}
    validates_presence_of :nombre, :cargo, :lugar_trabajo
    validates_presence_of :email, if: -> {[nil, false].include?(articulo_516)}

	def dnnc
		self.ownr.krn_denuncia
	end

	def fls(dc)
		self.rep_archivos.where(rep_doc_controlado_id: dc.id).crtd_ordr
	end

	def fl(dc)
		self.fls(dc).last
	end

	def fl?(code)
		dc = RepDocControlado.get_dc(code)
		fl(dc).present?
	end

	def self.emprss_ids
		all.map {|den| den.krn_empresa_externa_id}.uniq
	end

	# ----------------------------------------------------------

	def css_id
		"tstg#{self.id}"
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnTestigo').rep_doc_controlados.ordr
	end

	def denuncia
		self.ownr.denuncia
	end

	def fl_prtcpnts_dclrcn?
		self.krn_declaraciones.any?
	end

	def fl_prtcpnts_antcdnts?
		self.krn_declaraciones.any?
	end

	# --------------------------------------

	def self.rlzds?
 		arr = all.map {|tes| tes.krn_declaraciones.rlzds?}.uniq
 		arr.length == 1 and arr[0] == true
	end

end
