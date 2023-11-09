class AddClienteIdToOrgArea < ActiveRecord::Migration[5.2]
  def change
    add_column :org_areas, :cliente_id, :integer
    add_index :org_areas, :cliente_id
  end
end
