class AddBoolToValor < ActiveRecord::Migration[7.1]
  def change
    add_column :valores, :c_booleano, :boolean

    rename_column :valores, :owner_class, :ownr_type
    rename_column :valores, :owner_id, :ownr_id
  end
end
