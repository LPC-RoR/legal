class AddMinMaxToDtMulta < ActiveRecord::Migration[7.1]
  def change
    add_column :dt_multas, :dt_tramo_multa_id, :integer
    add_index :dt_multas, :dt_tramo_multa_id
  end
end
