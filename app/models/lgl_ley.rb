class LglLey < ApplicationRecord
	belongs_to :lgl_repositorio

	has_many :act_archivos, as: :ownr
end
