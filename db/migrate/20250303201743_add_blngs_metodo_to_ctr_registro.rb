class AddBlngsMetodoToCtrRegistro < ActiveRecord::Migration[8.0]
  def change
    add_column :ctr_pasos, :blngs_metodo, :string
  end
end
