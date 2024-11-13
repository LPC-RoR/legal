class AddPfieldsToProducto < ActiveRecord::Migration[7.1]
  def change
    rename_column :productos, :code_descripcion, :codigo
 
    add_column :productos, :tipo, :string
    add_index :productos, :tipo
    add_column :productos, :procedimiento_id, :integer
    add_index :productos, :procedimiento_id
    add_column :productos, :formato, :string
    add_column :productos, :prepago, :boolean
    add_column :productos, :capacidad, :integer
    add_column :productos, :moneda, :string
    add_column :productos, :precio, :decimal
  end
end