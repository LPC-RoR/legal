class KrnDeclaracion < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_investigador
 	belongs_to :ownr, polymorphic: true

	has_many :pdf_registros, as: :ref
	has_many :check_realizados, as: :ownr, dependent: :destroy

	before_validation :truncate_seconds

    validates_presence_of :fecha

 	scope :fecha_ordr, -> {order(fecha: :desc)}

 	def dnnc
 		self.ownr.dnnc
 	end

	def tiene_check_realizado?
		check_realizados.exists?(cdg: 'dclrcn',rlzd: true)
	end

 	def destinatario
 		[{ objt: ownr, email: ownr.email, nombre: ownr.nombre }]
 	end

	def dflt_bck_rdrccn
		"/krn_denuncias/#{self.dnnc.id}_1"
	end

 	def invstgdr_objtd?
 		self.krn_denuncia.objcn_invstgdr? and self.krn_denuncia.krn_inv_denuncias.first.id == self.krn_investigador_id
 	end

 	def invstgdr_elmnd?
 		self.krn_denuncia.krn_investigadores.ids.include?(self.krn_investigador_id) == false
 	end

	private

	def truncate_seconds
	  self.fecha = fecha&.change(sec: 0, usec: 0)
	end
end
