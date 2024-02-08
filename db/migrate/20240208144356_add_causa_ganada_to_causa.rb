class AddCausaGanadaToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :causa_ganada, :boolean
    add_index :causas, :causa_ganada
  end
end
