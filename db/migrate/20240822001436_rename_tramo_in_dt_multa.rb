class RenameTramoInDtMulta < ActiveRecord::Migration[7.1]
  def change
    rename_column :dt_multas, :dt_tramo_multa_id, :dt_tramo_id
  end
end
