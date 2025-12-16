class RemoveTipoCausaIdFromCausa < ActiveRecord::Migration[8.0]
  def change
    remove_column :causas, :tipo_causa_id, :integer
    remove_column :tar_tarifas, :tipo_causa_id, :integer
    remove_column :tar_tipo_variables, :tipo_causa_id, :integer
  end
end
