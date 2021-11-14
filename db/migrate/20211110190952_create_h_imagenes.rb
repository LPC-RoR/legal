class CreateHImagenes < ActiveRecord::Migration[5.2]
  def change
    create_table :h_imagenes do |t|
      t.string :nombre

      t.timestamps
    end
    add_index :h_imagenes, :nombre
  end
end
