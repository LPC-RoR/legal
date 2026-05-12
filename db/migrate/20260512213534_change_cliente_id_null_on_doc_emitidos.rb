class ChangeClienteIdNullOnDocEmitidos < ActiveRecord::Migration[8.0]
  def change
    change_column_null :doc_emitidos, :cliente_id, true
  end
end
