class AddFieldsToComRequerimiento < ActiveRecord::Migration[8.0]
  def change
    add_column :com_requerimientos, :ownr_type, :string
    add_index :com_requerimientos, :ownr_type
    add_column :com_requerimientos, :ownr_id, :integer
    add_index :com_requerimientos, :ownr_id
    add_column :com_requerimientos, :realizada, :boolean
    add_index :com_requerimientos, :realizada
  end
end
