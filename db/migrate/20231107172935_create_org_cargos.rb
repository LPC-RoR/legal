class CreateOrgCargos < ActiveRecord::Migration[5.2]
  def change
    create_table :org_cargos do |t|
      t.string :org_cargo
      t.integer :dotacion
      t.integer :org_area_id

      t.timestamps
    end
    add_index :org_cargos, :org_area_id
  end
end
