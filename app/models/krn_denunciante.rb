class KrnDenunciante < ApplicationRecord
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

	validates :rut, valida_rut: true
	validates_presence_of :rut, :nombre, :cargo, :lugar_trabajo
	validates_presence_of :email, if: -> {[nil, false].include?(articulo_516)}

	include Prtcpnt
	include Fls

 	# ================================= GENERAL

	# Se usa para resolver bck_rdrccn
	def ownr
		self.krn_denuncia
	end

 	# --------------------------------- PDF Archivos y registros

 	def dnncnt_info_oblgtr?
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
		all.map {|arc| arc.fl_diat_diep?}.exclude?(false)
	end

end
