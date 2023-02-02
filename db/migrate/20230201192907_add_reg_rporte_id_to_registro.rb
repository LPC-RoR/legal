class AddRegRporteIdToRegistro < ActiveRecord::Migration[5.2]
  def change
    add_column :registros, :RegReporteId, :integer
    add_index :registros, :RegReporteId
  end
end
