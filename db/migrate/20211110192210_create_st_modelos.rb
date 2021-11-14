class CreateStModelos < ActiveRecord::Migration[5.2]
  def change
    create_table :st_modelos do |t|
      t.string :st_modelo

      t.timestamps
    end
    add_index :st_modelos, :st_modelo
  end
end
