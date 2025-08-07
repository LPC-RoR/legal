class Nota < ApplicationRecord

	belongs_to :ownr, polymorphic: true
	belongs_to :app_perfil

	has_many :age_usu_notas
	has_many :age_usuarios, through: :age_usu_notas

	validates :nota, presence: true

	scope :crtd_at_asc, -> { order(:created_at) }

	scope :no_rlzds, -> { where(realizado: [false, nil]) }
	scope :rlzds, -> { where(realizado: true) }

	def dflt_bck_rdrccn
		if ['KrnDenuncia'].include?(self.ownr.class.name)
		  "/krn_denuncias/#{self.ownr.dnnc.id}_0"
		else
		  self.ownr
		end
	end

end