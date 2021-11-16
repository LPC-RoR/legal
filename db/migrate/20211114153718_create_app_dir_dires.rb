class CreateAppDirDires < ActiveRecord::Migration[5.2]
  def change
    create_table :app_dir_dires do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
    add_index :app_dir_dires, :parent_id
    add_index :app_dir_dires, :child_id
  end
end
