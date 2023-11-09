class OrgAreaArea < ApplicationRecord
  belongs_to :parent, :class_name => "OrgArea", :inverse_of => :parent_relation
  belongs_to :child, :class_name => "OrgArea", :inverse_of => :child_relations
end
