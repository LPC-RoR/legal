class AddDescripcionToVariable < ActiveRecord::Migration[5.2]
  def change
    add_column :variables, :descripcion, :string
    add_index :variables, :descripcion
  end
end
