class AppMensaje < ApplicationRecord

	belongs_to :app_perfil, optional: true

	has_one  :parent_relation, :foreign_key => "child_id",
                              :class_name => "AppMsgMsg"
	has_many :child_relations, :foreign_key => "parent_id", 
                              :class_name => "AppMsgMsg"

	has_one  :parent, :through => :parent_relation
	has_many :children, :through => :child_relations, :source => :child

	def author
		self.app_perfil.present? ? app_perfil.email : 'anónimo'
	end

end
