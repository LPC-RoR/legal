class KrnDenunciante < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_empleado, optional: true

	has_many :rep_archivos, as: :ownr
	has_many :krn_declaraciones, as: :ownr
	has_many :krn_testigos, as: :ownr
	has_many :valores, as: :ownr

	delegate :rut, to: :krn_empresa_externa, prefix: true

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true
    validates_presence_of :rut, :nombre, :cargo, :lugar_trabajo
    validates_presence_of :email, if: -> {[nil, false].include?(articulo_516)}

	include Procs
	include Ntfccns
	include Valores

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

	def self.emprss_ids
		all.map {|den| den.krn_empresa_externa_id}
	end

	def self.art4_1?
		all.map { |den| den.articulo_4_1 }.include?(true)
	end

	def self.art516?
		all.map { |den| den.articulo_516 }.include?(true)
	end

	def self.rgstrs_ok?
		arry = all.map {|den| den.rgstr_ok?}.uniq
		arry.length == 1 and arry[0] == true
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

	# --------------------------------------------------------------- DCLRCN

	def dclrcn?
		self.krn_declaraciones.any? and ( not self.krn_testigos.map {|tst| tst.dclrcn?}.include?(false) )
	end

	# --------------------------------------------------------------- METHODS
	def rgstr_ok?
		empldr = self.empleado_externo ? self.emprs_extrn_prsnt? : true
		ntfccn = self.articulo_516 ? self.direccion_notificacion.present? : self.email.present?
		empldr and ntfccn
	end

end
