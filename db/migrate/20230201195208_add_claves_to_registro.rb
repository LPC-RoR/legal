class AddClavesToRegistro < ActiveRecord::Migration[5.2]
  def change
    add_column :registros, :annio, :integer
    add_index :registros, :annio
    add_column :registros, :mes, :integer
    add_index :registros, :mes
  end
end
