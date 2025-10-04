class DropOrgsAreaArea < ActiveRecord::Migration[8.0]
  def change
    drop_table :org_area_areas
  end
end
