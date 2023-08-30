class AddDtInfraccionIdToDtMulta < ActiveRecord::Migration[5.2]
  def change
    add_column :dt_multas, :dt_infraccion_id, :integer
    add_index :dt_multas, :dt_infraccion_id
  end
end
