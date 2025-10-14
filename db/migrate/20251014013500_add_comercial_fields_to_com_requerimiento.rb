class AddComercialFieldsToComRequerimiento < ActiveRecord::Migration[8.0]
  def change
    add_column :com_requerimientos, :motivo, :string
    add_index :com_requerimientos, :motivo
    add_column :com_requerimientos, :mensaje, :text
  end
end
