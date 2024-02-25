class AddDescripcionToHecho < ActiveRecord::Migration[5.2]
  def change
    add_column :hechos, :descripcion, :text
  end
end
