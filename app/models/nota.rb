class Nota < ApplicationRecord

	CLRS = {
		'normal'	=> 'success',
		'mediana'	=> 'warning',
		'urgente'	=> 'danger',
	}

	belongs_to :ownr, polymorphic: true
	belongs_to :usuario

	has_many :responsables_notas,
           class_name: 'ResponsableNota',   # <-- aquí
           dependent: :destroy
	has_many :responsables, through: :responsables_notas,
	                          source: :usuario

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