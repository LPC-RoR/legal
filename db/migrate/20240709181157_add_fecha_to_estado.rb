class AddFechaToEstado < ActiveRecord::Migration[7.1]
  def change
    add_column :estados, :fecha, :datetime
    add_index :estados, :fecha
  end
end
