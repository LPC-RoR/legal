class AppDirDir < ApplicationRecord
  belongs_to :parent, :class_name => "AppDirectorio", :inverse_of => :parent_relation
  belongs_to :child, :class_name => "AppDirectorio", :inverse_of => :child_relations
end
