class RemoveUniqueIndexFromCliAprobaciones < ActiveRecord::Migration[8.0]
  def change
    # Si el índice existe, elimínalo
    remove_index :cli_aprobaciones, [:cliente_id, :fecha] if index_exists?(:cli_aprobaciones, [:cliente_id, :fecha])
  end
end
