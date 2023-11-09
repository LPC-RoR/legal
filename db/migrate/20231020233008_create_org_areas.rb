class CreateOrgAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :org_areas do |t|
      t.string :org_area

      t.timestamps
    end
  end
end
