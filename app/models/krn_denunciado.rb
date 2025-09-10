class KrnDenunciado < ApplicationRecord
	include EmailVerifiable

	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_empleado, optional: true

	has_many :act_archivos, as: :ownr
	has_many :check_auditorias, as: :ownr
	has_many :audit_notas, as: :ownr

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

	include Prtcpnt
	include Fls

	def sym
		:dnncd
	end

	# -------------------------------- General

	def dnnc
		self.krn_denuncia
	end

	# Se usa para resolver bck_rdrccn
	def ownr
		self.krn_denuncia
	end

	# --------------------------------- Asociaciones

 	def declaraciones?
 		self.krn_declaraciones.any?
 	end

 	def testigos?
 		self.krn_testigos.any?
 	end

end
