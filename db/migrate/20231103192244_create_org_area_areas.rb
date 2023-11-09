class CreateOrgAreaAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :org_area_areas do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
    add_index :org_area_areas, :parent_id
    add_index :org_area_areas, :child_id
  end
end
