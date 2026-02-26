class KrnDenunciante < ApplicationRecord
#	include EmailVerifiable

	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_empleado, optional: true

	has_many :act_archivos, as: :ownr, dependent: :destroy
	has_many :check_realizados, as: :ownr, dependent: :destroy
	has_many :check_auditorias, as: :ownr, dependent: :destroy
	has_many :audit_notas, as: :ownr, dependent: :destroy

	has_many :rep_archivos, as: :ownr, dependent: :destroy
	
	has_many :notas, as: :ownr, dependent: :destroy
	has_many :pdf_registros, as: :ownr, dependent: :destroy

	has_many :krn_declaraciones, as: :ownr, dependent: :destroy
	has_many :krn_testigos, as: :ownr, dependent: :destroy

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
	validates_presence_of :krn_empresa_externa_id, if: -> {empleado_externo}
	validates_presence_of :direccion_notificacion, if: -> {articulo_516}

	include Cptn

	include Prtcpnt
	include Fls

	def sym
		:dnncnt
	end

	def rol
		'denunciante'
	end

 	# ================================= GENERAL

	# Se usa para resolver bck_rdrccn
	def ownr
		self.krn_denuncia
	end

 	# --------------------------------- PDF Archivos y registros

 	def info_oblgtr?
 		pdf = PdfArchivo.find_by(codigo: 'dnncnt_info_oblgtr')
 		pdf.blank? ? nil : self.pdf_registros.find_by(pdf_archivo_id: pdf.id).present?
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

	def self.diats_dieps_ok?
		all.empty? ? false : all.map {|arc| arc.fl_diat_diep?}.exclude?(false)
	end

	# En cada modelo (KrnDenunciante, KrnInvestigador, etc.)
	# verification_sent_at marca recepción de la verificación, se añade email == email_ok para manejar cambios de email
	def verified?
	  verification_sent_at.present? and email == email_ok
	end

	def tiene_check_realizado?
		check_realizados.exists?(cdg: 'verificar_email',rlzd: true)
	end

end
