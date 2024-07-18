class CreateLglParraParras < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_parra_parras do |t|
      t.integer :child_id
      t.integer :parent_id

      t.timestamps
    end
    add_index :lgl_parra_parras, :child_id
    add_index :lgl_parra_parras, :parent_id
  end
end
