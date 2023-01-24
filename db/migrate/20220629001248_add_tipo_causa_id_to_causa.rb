class AddTipoCausaIdToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :tipo_causa_id, :integer
    add_index :causas, :tipo_causa_id
  end
end
