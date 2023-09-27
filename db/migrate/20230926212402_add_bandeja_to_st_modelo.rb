class AddBandejaToStModelo < ActiveRecord::Migration[5.2]
  def change
    add_column :st_modelos, :bandeja, :boolean
    add_index :st_modelos, :bandeja
  end
end
