class AddOrdenToCtrRegistro < ActiveRecord::Migration[8.0]
  def change
    add_column :ctr_registros, :orden, :integer
    add_index :ctr_registros, :orden
  end
end
