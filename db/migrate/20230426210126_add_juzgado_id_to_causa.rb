class AddJuzgadoIdToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :juzgado_id, :integer
    add_index :causas, :juzgado_id
  end
end
