class AddEstadoToDocTransacciones < ActiveRecord::Migration[8.0]
  def change
    add_column :doc_transacciones, :estado, :integer, default: 0, null: false
    add_index  :doc_transacciones, :estado
  end
end
