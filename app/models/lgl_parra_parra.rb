class LglParraParra < ApplicationRecord
  belongs_to :parent, :class_name => "LglParrafo", :inverse_of => :parent_relation
  belongs_to :child, :class_name => "LglParrafo", :inverse_of => :child_relations
end
