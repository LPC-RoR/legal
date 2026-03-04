class ActReferencia < ApplicationRecord
	belongs_to :act_archivo
	belongs_to :res, polymorphic: true
end
