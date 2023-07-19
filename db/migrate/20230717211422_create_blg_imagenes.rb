class CreateBlgImagenes < ActiveRecord::Migration[5.2]
  def change
    create_table :blg_imagenes do |t|
      t.string :blg_imagen
      t.string :imagen
      t.string :blg_credito
      t.string :ownr_class
      t.integer :ownr_id

      t.timestamps
    end
    add_index :blg_imagenes, :blg_imagen
    add_index :blg_imagenes, :ownr_class
    add_index :blg_imagenes, :ownr_id
  end
end
