class KrnDenunciado < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_empleado, optional: true

	has_many :rep_archivos, as: :ownr
	has_many :krn_declaraciones, as: :ownr
	has_many :krn_testigos, as: :ownr
	has_many :valores, as: :ownr

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true, if: -> {rut.present?}
    validates_presence_of :nombre, :cargo, :lugar_trabajo

	include Procs
	include Ntfccns
	include Valores

	def prtl_cndtn
		{
			ntfccn: {
				cndtn: self.direccion_notificacion.present?,
				trsh: (not self.krn_denuncia.invstgdr?)
			},
		}
	end

	def css_id
		"dnncd#{self.id}"
	end

	def self.emprss_ids
		all.map {|den| den.krn_empresa_externa_id}
	end

	def self.art4_1?
		all.map { |den| den.articulo_4_1 }.include?(true)
	end

	def self.art516?
		all.map { |den| den.articulo516 }.include?(true)
	end

	def self.rgstrs_fail?
		all.map {|den| den.rgstr_ok?}.include?(false)
	end

	def rgstr_ok?
		self.flds_ok? and (self.articulo_516 ? self.direccion_notificacion.present? : true)
	end

	def flds_ok?
		self.rut.present? and self.email.present?
	end

	def empleador
		self.krn_empresa_externa_id.blank? ? 'Empleado de la empresa' : self.krn_empresa_externa.razon_social
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnDenunciado').rep_doc_controlados.ordr
	end

	def denuncia
		self.krn_denuncia
	end

	# --------------------------------------------------------------- DCLRCN

	def dclrcn?
		self.krn_declaraciones.any? and ( not self.krn_testigos.map {|tst| tst.dclrcn?}.include?(false) )
	end

end
