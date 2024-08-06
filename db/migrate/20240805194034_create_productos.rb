class CreateProductos < ActiveRecord::Migration[7.1]
  def change
    create_table :productos do |t|
      t.string :producto
      t.string :code_descripcion

      t.timestamps
    end
    add_index :productos, :code_descripcion
  end
end
