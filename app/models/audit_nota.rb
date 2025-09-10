class AuditNota < ApplicationRecord
	belongs_to :ownr, polymorphic: true
	belongs_to :app_perfil
end
