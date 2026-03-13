class ActReferencia < ApplicationRecord
	belongs_to :act_archivo
	belongs_to :ref, polymorphic: true
end
