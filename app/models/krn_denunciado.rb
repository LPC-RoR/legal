class KrnDenunciado < ApplicationRecord
	include EmailVerifiable

	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_empleado, optional: true

	has_many :rep_archivos, as: :ownr
	has_many :notas, as: :ownr
	has_many :pdf_registros, as: :ownr

	has_many :krn_declaraciones, as: :ownr
	has_many :krn_testigos, as: :ownr

	delegate :rut, :razon_social, to: :krn_empresa_externa, prefix: true

	scope :rut_ordr, -> {order(:rut)}

	scope :artcl41, -> { where(articulo_4_1: true) }
	scope :artcl516, -> { where(articulo516: true) }

	# Externas y propias
	scope :extrns, -> { where.not(krn_empresa_externa_id: nil) }
	scope :prps, -> { where(krn_empresa_externa_id: nil) }

	validates :rut, valida_rut: true, if: -> {rut.present?}
    validates_presence_of :nombre, :cargo, :lugar_trabajo, :relacion_denunciante

	include Ntfccns
	include Fls

	# -------------------------------- General

	def dnnc
		self.krn_denuncia
	end

	def dflt_bck_rdrccn
		"/krn_denuncias/#{self.dnnc.id}_1"
	end

	# Se usa para resolver bck_rdrccn
	def ownr
		self.krn_denuncia
	end

	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
	def verified?
	  verification_sent_at.present?
	end

	# --------------------------------- Asociaciones

 	def declaraciones?
 		self.krn_declaraciones.any?
 	end

 	def testigos?
 		self.krn_testigos.any?
 	end

 	# ================================= 020_prtcpnts: Ingreso de(l) denunciante(s)

	def fl_diat_diep?
		self.fl?('dnncnt_diat_diep')
	end 

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
		self.empleador_ok? and self.direccion_ok? and self.rut? and self.krn_testigos.rgstrs_ok?
	end

	def self.rgstrs_ok?
		all.empty? ? false : all.map {|den| den.rgstr_ok?}.uniq.join('-') == 'true'
	end

 	# --------------------------------- Despliegue de formularios

	def self.emprss_ids
		all.map {|den| den.krn_empresa_externa_id if !!den.empleado_externo}.uniq
	end

	# ------------------------------------------------------------------------

	def empleador_ok?
		self.empleado_externo ? self.krn_empresa_externa.present? : true
	end

	def direccion_ok?
		self.articulo_516 ? self.direccion_notificacion.present? : self.email.present?
	end

	def dclrcn?
		self.fl?('prtcpnts_dclrcn') and self.krn_testigos.dclrcns?
	end

	def self.dclrcns?
		all.empty? ? false : all.map {|objt| objt.dclrcn?}.uniq.join('-') == 'true'
	end

 	def self.rlzds?
 		all.empty? ? false : all.map {|objt| objt.rlzd}.uniq.join('-') == 'true'
 	end

	def dclrcns_rlzds?
 		self.krn_declaraciones.rlzds? and self.krn_testigos.rlzds?
	end

	# ------------------------------------------------------------------------ INGRS

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
			},
		}
	end

	def dclrcn_ok?
		dc = RepDocControlado.get_dc('prtcpnts_dclrcn')
		self.rep_archivos.find_by(rep_doc_controlado_id: dc.id).present?
	end

	def krn_empresa_externa?
		self.krn_empresa_externa_id.present?
	end

	def self.rgstrs_fail?
		all.map {|den| den.rgstr_ok?}.include?(false)
	end

	def empleador
		self.empleado_externo ? (self.krn_empresa_externa.present? ? self.krn_empresa_externa.razon_social : 'Pendiente de ingreso') : 'Empleado de la empresa'
	end

	def dnnc_fech_trmitcn?
		self.krn_denuncia.fecha_trmtcn.present?
	end

	def drccn_ntfccn_prsnt?
		self.direccion_notificacion.present?
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnDenunciado').rep_doc_controlados.ordr
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
