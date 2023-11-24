class CreateOrgRegiones < ActiveRecord::Migration[5.2]
  def change
    create_table :org_regiones do |t|
      t.string :org_region
      t.integer :cliente_id
      t.integer :region_id
      t.integer :orden

      t.timestamps
    end
    add_index :org_regiones, :org_region
    add_index :org_regiones, :region_id
    add_index :org_regiones, :cliente_id
    add_index :org_regiones, :orden
  end
end
