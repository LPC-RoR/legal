class KrnDenunciante < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_empleado, optional: true

	has_many :rep_archivos, as: :ownr
	has_many :krn_declaraciones, as: :ownr
	has_many :krn_testigos, as: :ownr

	scope :rut_ordr, -> {order(:rut)}

	validates :rut, valida_rut: true
    validates_presence_of :rut, :nombre, :cargo, :lugar_trabajo, :email

	def css_id
		"dnncnt#{self.id}"
	end

	def self.emprss_ids
		all.map {|den| den.krn_empresa_externa_id}
	end

	def self.art4_1?
		all.map { |den| den.articulo_4_1 }.include?(true)
	end

	def empleador
		self.krn_empresa_externa_id.blank? ? 'Empleado de la empresa' : self.krn_empresa_externa.razon_social
	end

	def self.doc_cntrlds
		StModelo.get_model('KrnDenunciante').rep_doc_controlados.ordr
	end

	def denuncia
		self.krn_denuncia
	end

	# --------------------------------------------------------------- DCLRCN

	def dsply_dclrcn?
		self.krn_declaraciones.any?
	end

end
