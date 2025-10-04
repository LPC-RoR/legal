class KrnTestigo < ApplicationRecord
	include EmailVerifiable

 	belongs_to :ownr, polymorphic: true

	belongs_to :krn_empresa_externa, optional: true


	has_many :act_archivos, as: :ownr, dependent: :destroy
	has_many :check_realizados, as: :ownr, dependent: :destroy
	has_many :check_auditorias, as: :ownr, dependent: :destroy
	has_many :audit_notas, as: :ownr, dependent: :destroy

	has_many :notas, as: :ownr, dependent: :destroy
	has_many :pdf_registros, as: :ownr, dependent: :destroy

	has_many :krn_declaraciones, as: :ownr, dependent: :destroy

	has_many :rep_archivos, as: :ownr, dependent: :destroy

	delegate :rut, :razon_social, to: :krn_empresa_externa, prefix: true

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true, if: -> {rut.present?}
    validates_presence_of :nombre, :cargo, :lugar_trabajo
#    validates_presence_of :email, if: -> {[nil, false].include?(articulo_516)}
	validates_presence_of :krn_empresa_externa_id, if: -> {empleado_externo}
	validates_presence_of :direccion_notificacion, if: -> {articulo_516}

	include Cptn

	include Prtcpnt
	include Fls

	def sym
		:tstg
	end

	def rol
		'testigo'
	end

	def dnnc
		self.ownr.krn_denuncia
	end

 	# --------------------------------- Asociaciones

 	def declaraciones?
 		self.krn_declaraciones.any?
 	end

end