class DropProductos < ActiveRecord::Migration[8.0]
  def change
   drop_table :productos
   drop_table :pro_dtll_ventas
  end
end
