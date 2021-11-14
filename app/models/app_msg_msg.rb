class AppMsgMsg < ApplicationRecord
  belongs_to :parent, :class_name => "AppMensaje", :inverse_of => :parent_relation
  belongs_to :child, :class_name => "AppMensaje", :inverse_of => :child_relations
end
