class CreateTarVariables < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_variables do |t|
      t.string :variable
      t.string :owner_class
      t.integer :owner_id
      t.decimal :porcentaje

      t.timestamps
    end
    add_index :tar_variables, :owner_class
    add_index :tar_variables, :owner_id
  end
end
