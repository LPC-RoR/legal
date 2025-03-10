class KrnDenunciante < ApplicationRecord

	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_empleado, optional: true

	has_many :ctr_registros, as: :ownr

	has_many :rep_archivos, as: :ownr
	has_many :krn_declaraciones, as: :ownr
	has_many :krn_testigos, as: :ownr
	has_many :valores, as: :ownr

	delegate :rut, to: :krn_empresa_externa, prefix: true
	delegate :rut, :razon_social, to: :krn_empresa_externa, prefix: true

	scope :rut_ordr, -> {order(:rut)}

	scope :artcl41, -> { where(articulo_4_1: true) }
	scope :artcl516, -> { where(articulo516: true) }

	# Externas y propias
	scope :extrns, -> { where.not(krn_empresa_externa_id: nil) }
	scope :prps, -> { where(krn_empresa_externa_id: nil) }

	validates :rut, valida_rut: true
    validates_presence_of :rut, :nombre, :cargo, :lugar_trabajo
    validates_presence_of :email, if: -> {[nil, false].include?(articulo_516)}

	include Procs
	include Ntfccns
	include Valores


	def fls(dc)
		self.rep_archivos.where(rep_doc_controlado_id: dc.id).crtd_ordr
	end

	def fl(dc)
		self.fls(dc).last
	end

	def self.emprss_ids
		all.map {|den| den.krn_empresa_externa_id}.uniq
	end

	# ------------------------------------------------------------------------ INGRS

	def p_empleador?
		self.krn_empresa_externa_id.blank?
	end

	def p_direccion?
		self.direccion_notificacion.blank?
	end

	def fl_dnncnt_diat_diep?
		true
	end

	def rgstr_ok?
		empldr = self.empleado_externo ? self.krn_empresa_externa.present? : true
		ntfccn = self.articulo_516 ? self.direccion_notificacion.present? : self.email.present?
		empldr and ntfccn
	end

	def self.rvsds?
		arry = all.map {|den| den.registro_revisado}.uniq
		arry.length == 1 and arry[0] == true
	end

	# DEPRECATED
	def self.rgstrs_ok?
		arry = all.map {|den| den.rgstr_ok?}.uniq
		arry.length == 1 and arry[0] == true
	end

	# ------------------------------------------------------------------------------



	def prtl_cndtn
		{
			externa_id: {
				cndtn: self.krn_empresa_externa.present?,
				trsh: ( not self.krn_denuncia.fecha_trmtcn.present?)
			},
			ntfccn: {
				cndtn: self.direccion_notificacion.present?,
				trsh: (not self.krn_denuncia.fecha_trmtcn.present?)
			}
		}
	end

	def diat_diep?
		dc = RepDocControlado.get_dc('dnncnt_diat_diep')
		self.rep_archivos.find_by(rep_doc_controlado_id: dc.id).present?
	end 

	def dclrcn_ok?
		dc = RepDocControlado.get_dc('prtcpnts_dclrcn')
		self.rep_archivos.find_by(rep_doc_controlado_id: dc.id).present?
	end

	def self.diats_dieps_ok?
		all.map {|arc| arc.diat_diep?}.exclude?(false)
	end

	def self.dclrcns_ok?
		all.map {|arc| arc.rlzd == true}.exclude?(false)
	end

	def emprs_extrn_prsnt?
		self.krn_empresa_externa.present?
	end

	def dnnc_fech_trmitcn?
		self.krn_denuncia.fecha_trmtcn.present?
	end

	def drccn_ntfccn_prsnt?
		self.direccion_notificacion.present?
	end

	def css_id
		"dnncnt#{self.id}"
	end


	def self.rgstrs_fail?
		all.map {|den| den.rgstr_ok?}.include?(false)
	end

	def empleador
		self.empleado_externo ? (self.krn_empresa_externa.present? ? self.krn_empresa_externa.razon_social : 'Pendiente de ingreso') : 'Empleado de la empresa'
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnDenunciante').rep_doc_controlados.ordr
	end

	def denuncia
		self.krn_denuncia
	end

	# --------------------------------------------------------------- METHODS
	# --------------------------------------------------------------- VLRS

	def on_empresa?
		self.krn_denuncia.on_empresa?
	end

	def vlr_dnnc_eval_ok?
		self.krn_denuncia.vlr_dnnc_eval_ok?
	end	

	def dnnc_eval_ok?
		self.krn_denuncia.dnnc_eval_ok?
	end

end
