class KrnTestigo < ApplicationRecord
 	belongs_to :ownr, polymorphic: true
	belongs_to :krn_empresa_externa, optional: true

	has_many :notas, as: :ownr

	has_many :ctr_registros, as: :ownr

	has_many :krn_declaraciones, as: :ownr
	has_many :rep_archivos, as: :ownr

	delegate :rut, :razon_social, to: :krn_empresa_externa, prefix: true

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true, if: -> {rut.present?}
    validates_presence_of :nombre, :cargo, :lugar_trabajo
#    validates_presence_of :email, if: -> {[nil, false].include?(articulo_516)}

	include Fls

	def dnnc
		self.ownr.krn_denuncia
	end

 	# --------------------------------- Asociaciones

 	def declaraciones?
 		self.krn_declaraciones.any?
 	end

 	# ================================= 020_prtcpnts: Ingreso del participante

	def empleador?
		self.krn_empresa_externa_id?		
	end

	def informacion_adicional?
		self.empleado_externo or self.articulo_516
	end

	def proc_empleador?
		self.empleado_externo
	end

	def proc_direccion?
		self.articulo_516
	end

	def rgstr_ok?
		self.empleador_ok? and self.direccion_ok? and self.rut?
	end

	def self.rgstrs_ok?
		all.empty? ? true : all.map {|den| den.rgstr_ok?}.uniq.join('-') == 'true'
	end

 	# --------------------------------- Despliegue de formularios

	def self.emprss_ids
		all.map {|den| den.krn_empresa_externa_id if !!den.empleado_externo}.uniq
	end

	# ------------------------------------------------------------------------

	def css_id
		"tstg#{self.id}"
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnTestigo').rep_doc_controlados.ordr
	end

	def denuncia
		self.ownr.denuncia
	end

	# -------------------------------------- RLZDS

	def empleador_ok?
		self.empleado_externo ? self.krn_empresa_externa.present? : true
	end

	def direccion_ok?
		self.articulo_516 ? self.direccion_notificacion.present? : self.email.present?
	end

 	def self.rlzds?
 		all.empty? ? true : all.map {|objt| objt.rlzd}.uniq.join('-') == 'true'
 	end

 	def dclrcns_rlzds?
 		self.krn_declaraciones.rlzds?
 	end

end