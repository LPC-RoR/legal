class AddTipoCausaIdToTarTarifa < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_tarifas, :tipo_causa_id, :integer
    add_index :tar_tarifas, :tipo_causa_id
  end
end
