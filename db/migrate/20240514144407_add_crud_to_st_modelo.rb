class AddCrudToStModelo < ActiveRecord::Migration[5.2]
  def change
    add_column :st_modelos, :crud, :string
    add_index :st_modelos, :crud
  end
end
